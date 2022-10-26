#!/usr/bin/env bash
#Script para atualizar e limpar cache de pacotes antigos

clear

# O script precisa ser rodado como root (sudo)
[ $UID -ne 0 ] &&{ echo "Esse script deve ser executado como root!"; exit; }

# Obter ID da Distro
distroID=$(grep "^ID=" /etc/os-release)
distroID=${distroID#ID=}

case $distroID in
    arch|manjaro )
        echo "Atualizando o sistema..."
        pacman -Syu --noconfirm
        
        # Checar se flatpak está instalado, se sim, atualizar
        pacman -Q flatpak >/dev/null 2>&1 && { echo "Atualizando flatpaks..."; flatpack update -y; }

        # Checar se snapd está instalado, se sim, atualizar
        pacman -Q snapd >/dev/null 2>&1 && { echo "Atualizando snaps..."; snap refresh; }

        echo "Atualizações concluídas!"

        # Limpar cache de pacotes
        echo "Iniciando limpeza de pacotes..."

        pacman -Rsn $(pacman -Qdtq) --noconfirm; pacman -Scc --noconfirm
        
        echo "Limpeza do cache de pacotes e pacotes desncessários concluída!"
    ;;

    debian|ubuntu )
        echo "Atualizando o sistema..."
        apt update -y; apt full-upgrade -y

        # Checar se flatpak está instalado, se sim, atualizar
        dpkg -s flatpak >/dev/null 2>&1 && { echo "Atualizando flatpaks..."; flatpack update -y; }

        # Checar se snapd está instalado, se sim, atualizar
        dpkg -s snapd >/dev/null 2>&1 && { echo "Atualizando snaps..."; snap refresh; }

        echo "Atualizações concluídas!"

        # Limpar cache de pacotes
        echo "Iniciando limpeza de pacotes..."

        apt autoremove -y; apt autoclean -y; apt clean

        echo "Limpeza do cache de pacotes e pacotes desncessários concluída!"
    ;;

    sles|opensuse )
        echo "Atualizando o sistema..."
        zypper dup -y

        # Checar se flatpak está instalado, se sim, atualizar
        zypper search --installed-only flatpak >/dev/null 2>&1 && { echo "Atualizando flatpaks..."; flatpack update -y; }

        # Checar se snapd está instalado, se sim, atualizar
        zypper search --installed-only snapd >/dev/null 2>&1 && { echo "Atualizando snaps..."; snap refresh; }

        echo "Atualizações concluídas!"

        # Limpar cache de pacotes
        echo "Iniciando limpeza de pacotes..."

        zypper rm $(zypper packages --unneeded) -y; zypper clean -y

        echo "Limpeza do cache de pacotes e pacotes desncessários concluída!"
    ;;

    fedora|centos )
        echo "Atualizando o sistema..."
        dnf distro-sync

        # Checar se flatpak está instalado, se sim, atualizar
        dnf list flatpak >/dev/null 2>&1 && { echo "Atualizando flatpaks..."; flatpack update -y; }

        # Checar se snapd está instalado, se sim, atualizar
        dnf list snapd >/dev/null 2>&1 && { echo "Atualizando snaps..."; snap refresh; }

        echo "Atualizações concluídas!"

        # Limpar cache de pacotes
        echo "Iniciando limpeza de pacotes..."

        dnf autoremove; dnf clean all

        echo "Limpeza do cache de pacotes e pacotes desncessários concluída!"
    ;;
esac
