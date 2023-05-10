import os.path
import shutil
import sysconfig
from pathlib import Path

from setuptools import setup
from wheel.bdist_wheel import bdist_wheel

home_dir = Path.home()
install_dir = sysconfig.get_paths()['purelib']
print(home_dir)
print(install_dir)

VERSION = "2023.5.9"

current = Path(__file__).parent.absolute()


def generate_sumake(home_dir, current):
    sumake_dir = home_dir / ".sumake"
    bin_dir = current / "bin"

    utils_mk = sumake_dir / "utils.mk"

    if not os.path.exists(sumake_dir):
        os.makedirs(sumake_dir)
    if not os.path.exists(bin_dir):
        os.makedirs(bin_dir)
    print("current", current)

    shutil.copy(current / "utils.mk", utils_mk)
    # open("./sumake")
    with open(current / "./sumake", "r") as template:
        with open(bin_dir / "sumake", "w") as target:
            res = template.read().format(
                UTILS_MK=utils_mk,
                VERSION=VERSION, )
            target.write(res)


class PreInstallCommand(bdist_wheel):
    def run(self):
        generate_sumake(home_dir, current)
        bdist_wheel.run(self)


if __name__ == '__main__':
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
