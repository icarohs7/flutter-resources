import os
from os.path import join

subdirs = next(os.walk('.'))[1]
subdirs.remove(".git")
subdirs.remove(".github")

errs = 0
for subdir in subdirs:
    try:
        commands = [
            f"cd ./{subdir}",
            "flutter packages get",
            "flutter analyze",
            "flutter test --coverage"
        ]
        command = "&&".join(commands)
        result = os.system(command)
        if result != 0:
            raise RuntimeError()
        print(f"{subdir} built successfully")
        print("=================================================\n")
    except:
        errs += 1
        print(f"{subdir} failed to build")
        print("=================================================\n")

module_count = len(subdirs)
print("=================================================\n")
print(f"{module_count - errs}/{module_count} modules succeeded building")
print("=================================================\n")
if os.name == "nt":
    os.system("pause")
if errs > 0:
    raise RuntimeError()
