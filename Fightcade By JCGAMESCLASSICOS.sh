#!/bin/bash
# Curitiba 05/06 de Abril de 2026 >>  Feliz Pascoa 😸️ !!!
# Editor: Jeverson D. Silva /// @JCGAMESCLASSICOS
killall -9 teclado
export DISPLAY=:0
# --- RODA PYTHON EMBUTIDO EM BACKGROUND ---
nohup python3 << 'EOF' > /dev/null 2>&1 &
import os
import time
import xml.etree.ElementTree as ET
import pygame
import subprocess
import sys

BASE_DIR = '/userdata/system/.dev'
ES_INPUT_CFG = os.path.join(BASE_DIR, 'es_input.cfg')

def fightcade_ativo():
    try:
        out = subprocess.check_output(["wmctrl", "-l"]).decode("utf-8").lower()
        return any("fightcade" in linha for linha in out.splitlines())
    except:
        return False

def carregar_ids():
    start_ids = {}

    if not os.path.exists(ES_INPUT_CFG):
        start_ids['usb gamepad'] = 9
        return start_ids

    try:
        tree = ET.parse(ES_INPUT_CFG)
        root = tree.getroot()

        for inputConfig in root.findall('inputConfig'):
            name = inputConfig.attrib.get('deviceName', '').strip().lower()

            for inp in inputConfig.findall('input'):
                if inp.attrib.get('name').lower() == 'start':
                    start_ids[name] = int(inp.attrib.get('id'))
    except:
        pass

    return start_ids

def main():
    pygame.init()
    pygame.joystick.init()

    start_ids = carregar_ids()
    joysticks_map = {}
    last_joy_count = -1

    while True:

        # 🔥 NÃO PARA MAIS — apenas espera o Fightcade voltar
        if not fightcade_ativo():
            time.sleep(1)
            continue

        num = pygame.joystick.get_count()

        if num != last_joy_count:
            joysticks_map.clear()

            for i in range(num):
                js = pygame.joystick.Joystick(i)
                js.init()
                name = js.get_name().strip().lower()

                joysticks_map[i] = {
                    'obj': js,
                    'start_id': start_ids.get(name),
                    'press_time': None,
                    'executado': False
                }

            last_joy_count = num

        for event in pygame.event.get():

            if event.type == pygame.JOYBUTTONDOWN:
                js = joysticks_map.get(event.joy)
                if js and event.button == js['start_id']:
                    js['press_time'] = time.time()
                    js['executado'] = False

            elif event.type == pygame.JOYBUTTONUP:
                js = joysticks_map.get(event.joy)
                if js and event.button == js['start_id']:
                    js['press_time'] = None
                    js['executado'] = False

        for js in joysticks_map.values():
            if js['start_id'] is not None and js['press_time'] and not js['executado']:
                try:
                    if js['obj'].get_button(js['start_id']):
                        if time.time() - js['press_time'] >= 2:
                            subprocess.run(["pkill", "-9", "flycast"])
                            subprocess.run([ 
                                "killall", "-9",
                                "fcadefbneo.exe",
                                "flycast-dojo",
                                "flycast.elf",
                                "ggpofba-ng.exe",
                                "fcadesnes9x.exe"
                            ])
                            js['executado'] = True
                            js['press_time'] = None
                except:
                    pass

        time.sleep(0.01)

if __name__ == "__main__":
    try:
        main()
    finally:
        pygame.quit()
EOF

disown

# --- LIMPA CONFIG ---
#rm -rf /userdata/system/.config/Fightcade

if [ -d "/userdata/system/.dev" ]; then

    SCRIPT_NAME=$(basename "$0")
    EXPECTED_NAME="Fightcade By JCGAMESCLASSICOS.sh"

    if [ "$SCRIPT_NAME" != "$EXPECTED_NAME" ]; then
        exit 1
    fi

    # --- INICIA FIGHTCADE ---
    /userdata/system/.dev/apps/Fightcade/JCGAMESCLASSICOS #> /dev/null 2>&1 &

    # --- TECLADO ---
    #/userdata/system/.dev/apps/Fightcade/dep/rom/fightcade/teclado > /dev/null 2>&1 &

else
    mpv /userdata/system/.dev/efeitos_sonoros/menu_de_envio.mp3 > /dev/null 2>&1
    rm -f /userdata/system/.dev/coin
    rm -f /userdata/system/.dev/tempo_jogo.txt
fi