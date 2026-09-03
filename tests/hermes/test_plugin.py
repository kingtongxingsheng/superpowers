import importlib
import importlib.util
import os
import shutil
import sys
from pathlib import Path

import pytest

_PLUGIN_DIR = os.path.abspath(
    os.path.join(os.path.dirname(__file__), "../../.hermes-plugin")
)
sys.path.insert(0, _PLUGIN_DIR)


def _load_plugin():
    if "__init__" in sys.modules:
        del sys.modules["__init__"]
    return importlib.import_module("__init__")


class TestPluginRegistration:
    def test_register_has_no_hooks(self, mock_ctx):
        plugin = _load_plugin()
        plugin.register(mock_ctx)
        assert mock_ctx._hooks == {}

    def test_register_registers_every_stock_skill_as_path(self, mock_ctx):
        plugin = _load_plugin()
        plugin.register(mock_ctx)
        assert "brainstorming" in mock_ctx._skills
        for name, path in mock_ctx._skills.items():
            assert isinstance(path, Path)
            assert path.name == "SKILL.md"
            assert path.parent.name == name
            assert path.is_file()

    def test_registered_skills_match_skill_directories(self, mock_ctx):
        plugin = _load_plugin()
        plugin.register(mock_ctx)
        skills_root = plugin._skills_dir()
        expected = {
            entry
            for entry in os.listdir(skills_root)
            if os.path.isfile(os.path.join(skills_root, entry, "SKILL.md"))
        }
        assert set(mock_ctx._skills.keys()) == expected


class TestLayoutResolution:
    def _stage(self, tmp_path, layout):
        src_skills = Path(_PLUGIN_DIR).parent / "skills"
        if layout == "clone":
            plugdir = tmp_path / "superpowers" / ".hermes-plugin"
        else:
            plugdir = tmp_path / "superpowers"
        skills = tmp_path / "superpowers" / "skills"
        plugdir.mkdir(parents=True, exist_ok=True)
        shutil.copy(Path(_PLUGIN_DIR) / "__init__.py", plugdir / "__init__.py")
        shutil.copytree(src_skills / "brainstorming", skills / "brainstorming")
        return plugdir

    def _load_from(self, plugdir):
        spec = importlib.util.spec_from_file_location(
            f"hermes_plugin_test_{plugdir.parent.name}_{plugdir.name}",
            plugdir / "__init__.py",
        )
        mod = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(mod)
        return mod

    def test_clone_layout_resolves_sibling_skills(self, tmp_path, mock_ctx):
        mod = self._load_from(self._stage(tmp_path, "clone"))
        mod.register(mock_ctx)
        assert "brainstorming" in mock_ctx._skills

    def test_flat_layout_resolves_nested_skills(self, tmp_path, mock_ctx):
        mod = self._load_from(self._stage(tmp_path, "flat"))
        mod.register(mock_ctx)
        assert "brainstorming" in mock_ctx._skills

    def test_missing_skills_raises_loudly(self, tmp_path, mock_ctx):
        plugdir = tmp_path / "superpowers"
        plugdir.mkdir(parents=True)
        shutil.copy(Path(_PLUGIN_DIR) / "__init__.py", plugdir / "__init__.py")
        mod = self._load_from(plugdir)
        with pytest.raises(RuntimeError, match="cannot find the skills"):
            mod.register(mock_ctx)
