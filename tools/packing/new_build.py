#!/usr/bin/env python3

import os
import sys
import subprocess
import shutil

made = 0
failed = 0
skipped = 0
removed = 0

def mod_time(path):
    if not os.path.isdir(path):
        return os.path.getmtime(path)
    maxi = os.path.getmtime(path)
    for p in os.listdir(path):
        maxi = max(mod_time(os.path.join(path, p)), maxi)
    return maxi

def check_for_changes(addonspath, module, customAddonsPath):
    if addonspath == customAddonsPath:
        if not os.path.exists(os.path.join(addonspath, "{}.pbo".format(module))):
            return True
        return mod_time(os.path.join(addonspath, module)) > mod_time(os.path.join(addonspath, "{}.pbo".format(module)))
    else:
        if not os.path.exists(os.path.join(customAddonsPath, "{}.pbo".format(module))):
            return True
        return mod_time(os.path.join(addonspath, module)) > mod_time(os.path.join(customAddonsPath, "{}.pbo".format(module)))

def check_for_obsolete_pbos(addonspath, customAddonsPath, file):
    module = file[0:-4]  # Убираем расширение ".pbo"
    if not os.path.exists(os.path.join(addonspath, module)):
        return True
    return False

def build(armake, addonspath, addon, customAddonsPath):
    global made, skipped, removed, failed
    path = os.path.join(addonspath, addon)
    if not os.path.isdir(path):
        return
    if addon[0] == ".":
        return

    if not check_for_changes(addonspath, addon, customAddonsPath):
        skipped += 1
        print("Skipping {}.".format(addon))
        return

    print("# Making {} ...".format(addon))

    try:
        subprocess.check_output([
            armake,
            "build",
            "-p",
            "--force",
            path,
            "{}.pbo".format(path)
        ])
    except Exception as e:
        failed += 1
        print("Failed to make {}. Error: {}".format(addon, e))
    else:
        made += 1
        print("Successfully made {}.".format(addon))

        if customAddonsPath != addonspath:
            newPath = os.path.join(customAddonsPath, addon)
            shutil.move("{}.pbo".format(path), "{}.pbo".format(newPath))

def main():
    global made, skipped, removed, failed

    print("####################")
    print("# MKK SolidGames #")
    print("####################")

    # Указываем путь к кастомной директории и папке addons вручную
    customAddonsPath = "F:\\GIT\\@MKK-MODES\\addons" # папка куда запаковать файлы
    addonspath = "F:\\GIT\\@MKK-MODES\\addons"  # путь до папки addons гита

    scriptpath = os.path.realpath(__file__)
    armake = os.path.join(os.path.dirname(scriptpath), "armake_w64" if (sys.maxsize > 2**32) else "armake_w32")

    if not os.path.exists(customAddonsPath):
        try:
            os.mkdir(customAddonsPath)
        except FileExistsError:
            print("Custom directory already created")

    # Удаление устаревших .pbo в кастомной директории, если папки нет в addons
    for file in os.listdir(customAddonsPath):
        if file.endswith(".pbo"):
            if check_for_obsolete_pbos(addonspath, customAddonsPath, file):
                removed += 1
                print("Removing obsolete .pbo file from custom addons => " + file)
                os.remove(os.path.join(customAddonsPath, file))

    # Удаление устаревших файлов в addons
    for file in os.listdir(addonspath):
        if os.path.isfile(file):
            if check_for_obsolete_pbos(addonspath, addonspath, file):
                removed += 1
                print("Removing obsolete file => " + file)
                os.remove(file)

    print("")  # Пустая строка для визуального разделения в выводе

    # Сборка модулей
    for p in os.listdir(addonspath):
        build(armake, addonspath, p, customAddonsPath)

    print("# Done.")
    print("Made {}, skipped {}, removed {}, failed to make {}.".format(made, skipped, removed, failed))

    # Закрываем консоль автоматически по завершению скрипта
    input("\nНажмите Enter для закрытия консоли...")

if __name__ == "__main__":
    sys.exit(main())
