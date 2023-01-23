import os
from os import path

packages = [
    d[0] for d in os.walk('.')
    if path.isdir(d[0]) and 'pubspec.yaml' in os.listdir(d[0])
]

error_count = 0
for package_dir in packages:
    commands = [
        f'cd ./{package_dir}',
        'flutter packages get',
        'flutter analyze',
        'flutter test --coverage'
    ]
    command = '&&'.join(commands)
    return_code = os.system(command)
    if return_code == 0:
        print(f'{package_dir} built successfully')
        print('=================================================\n')
    else:
        error_count += 1
        print(f'{package_dir} failed to build')
        print('=================================================\n')

package_count = len(packages)
print('=================================================\n')
print(f'{package_count - error_count}/{package_count} modules succeeded building')
print('=================================================\n')
if error_count > 0:
    raise RuntimeError()
