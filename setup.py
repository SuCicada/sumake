import os.path
import shutil

from setuptools import find_packages
from setuptools import setup
import sysconfig

from setuptools.command.develop import develop
from setuptools.command.install import install
from wheel.bdist_wheel import bdist_wheel
from pathlib import Path

# home_dir = os.path.expanduser("~")
home_dir = Path.home()
install_dir = sysconfig.get_paths()['purelib']
print(home_dir)
print(install_dir)

VERSION = "2023.5.9"

current = Path(__file__).parent.absolute()
sumake_dir = home_dir / ".sumake"
utils_mk = sumake_dir / "utils.mk"
bin_dir = current / "bin"


class PreInstallCommand(bdist_wheel):
    def run(self):
        if not os.path.exists(sumake_dir):
            os.makedirs(sumake_dir)
        if not os.path.exists(bin_dir):
            os.makedirs(bin_dir)
        print("current", current)

        shutil.copy(current / "utils.mk", utils_mk)
        with open(bin_dir / "sumake", "w") as f:
            f.write(f"""
#!/bin/bash
make -f {utils_mk} $@
            """)
        bdist_wheel.run(self)


setup(
    author="SuCicada",
    author_email="pengyifu@gmail.com",
    classifiers=[],
    description="A generic makefile for projects.",
    scripts=["bin/sumake"],
    cmdclass={
        # "install": PreInstallCommand,
        "bdist_wheel": PreInstallCommand
    },
    install_requires=["setuptools"],

    # include_package_data=True,
    # install_requires=[],
    # keywords="",
    # license="",
    long_description=open("README.md").read(),
    name="sumake",
    # namespace_packages=[],
    # packages=find_packages(),
    # py_modules=["."],
    # test_suite="",
    url="https://github.com/SuCicada/sumake",
    version=VERSION,
    zip_safe=False,
)
