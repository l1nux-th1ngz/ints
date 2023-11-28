import subprocess
import os

def run_archinstall():
    archinstall_cmd = [
        'archinstall',
        '--timezone', 'America/New_York',
        '--hostname', 'my-arch-install',
        '--username', 'myuser',
        '--password', 'mypassword',
        '--root-password', 'rootpassword',
        '--bootloader-id', 'arch_grub',
        '--bootloader', 'grub',
        '--no-confirm',
        '--quiet',
    ]
    subprocess.run(archinstall_cmd, check=True)

def system_update_and_packages_installation():
    subprocess.run(['sudo', 'pacman', '-Syu', '--noconfirm'])
    packages_to_install = [
        'automake', 'autoconf', 'autoconf-archive',
        'glibc', 'base-devel', 'multilib-devel', 'libtool', 'gcc', 'git', 'wget', 'sof-firmware', 'pkgconf', 'xdg-user-dirs'
    ]
    subprocess.run(['sudo', 'pacman', '-S', '--noconfirm', '--needed'] + packages_to_install)
    subprocess.run(['xdg-user-dirs-update'])

def install_rust():
    pacman_command = ['sudo', 'pacman', '-S', '--noconfirm', '--needed', 'rustup']
    subprocess.run(pacman_command, check=True)
    set_default_rust_version('stable')

def set_default_rust_version(version):
    rustup_default_command = ['rustup', 'default', version]
    subprocess.run(rustup_default_command, check=True)

def run_task_with_rust_version(task_function, rust_version):
    current_default_version = get_default_rust_version()
    try:
        set_default_rust_version(rust_version)
        task_function()
    finally:
        set_default_rust_version(current_default_version)

def get_default_rust_version():
    rustup_show_default_command = ['rustup', 'show', 'default']
    result = subprocess.run(rustup_show_default_command, capture_output=True, text=True)
    return result.stdout.strip()

def task_requiring_specific_rust_version():
    print("Running task that requires a specific Rust version...")
    subprocess.run(['cargo', '--version'], check=True)

def install_yay():
    programs_dir = os.path.expanduser('~/Programs')
    os.makedirs(programs_dir, exist_ok=True)
    os.chdir(programs_dir)
    subprocess.run(['git', 'clone', 'https://aur.archlinux.org/yay.git'], check=True)
    os.chdir('yay')
    subprocess.run(['makepkg', '-si', '--noconfirm'], check=True)

def install_paru():
    os.chdir('~/Programs')
    subprocess.run(['git', 'clone', 'https://aur.archlinux.org/paru.git'], check=True)
    os.chdir('paru')
    subprocess.run(['makepkg', '-si', '--noconfirm'], check=True)

def choose_installer():
    print("Choose an installer to continue installation:")
    print("Yy for Yay or Pp for Paru")
    answer = input().lower()
    if answer.startswith('y'):
        installer = "yay"
    elif answer.startswith('p'):
        installer = "paru"
    else:
        print("Please answer Yy or Pp.")
        installer = None
    return installer

def install_with_chosen_installer(installer):
    if installer:
        for i in installer.split():
            subprocess.run([i, '-S', '--noconfirm'], check=True)

def install_additional_programs():
    with open('bldlist.txt', 'r') as file:
        package_list = file.read().splitlines()
    package_list = list(set(package_list))
    for package in package_list:
        subprocess.run([installer, '-S', '--noconfirm', package], check=True)

def apply_custom_configurations():
    subprocess.run(['cp', 'your_custom.css', '~/.config/waybar/your_custom.css'])
    subprocess.run(['cp', 'your_custom.jsonc', '~/.config/waybar/your_custom.jsonc'])
