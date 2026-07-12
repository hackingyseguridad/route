### route — Añadir ruta a otras redes en Linux

![Shell](https://img.shields.io/badge/Shell-100%25-89e051)
![Platform](https://img.shields.io/badge/plataforma-Linux%20%2F%20Debian-blue)

**route** es una colección de scripts en **Bash/Shell** para la administración de **red a nivel de sistema** en Linux (interfaces, rutas, VPN, Wi-Fi y diagnóstico), pensada como referencia rápida y como conjunto de utilidades ejecutables para tareas de **networking, pentesting y administración de sistemas**.

Mantenido por [hackingyseguridad.com](http://www.hackingyseguridad.com/) (Antonio Taboada — [@antonio_taboada](https://twitter.com/antonio_taboada)).

![route logo](https://github.com/hackingyseguridad/route/raw/master/route.png)

---

### Tabla de contenidos

- [¿Qué hace este repositorio?](#qué-hace-este-repositorio)
- [Requisitos previos](#requisitos-previos)
- [Estructura del repositorio](#estructura-del-repositorio)
- [Tabla resumen de scripts](#tabla-resumen-de-scripts)
- [Detalle de cada script](#detalle-de-cada-script)
  - [route.sh](#routesh--añadir-rutas-estáticas-a-otras-redes)
  - [ipotrasredes.sh](#ipotrasredessh--ip-alias-múltiples-redes-en-la-misma-interfaz)
  - [iwip / interfaces](#interfaces-e-interfaces2--plantillas-de-configuración-etcnetworkinterfaces)
  - [verinterfaces.sh](#verinterfacessh--resumen-de-ip-y-gateway-por-interfaz)
  - [verinterfaces2.sh](#verinterfaces2sh--activar-interfaces-y-relanzar-red)
  - [verrutas.sh](#verrutassh--ver-tabla-de-rutas-ipv4ipv6)
  - [vecinos.sh](#vecinossh--tabla-de-vecinos-ipv6-ndp)
  - [traceroute.sh](#tracerouteshttp--monitor-de-traceroute-con-whoisasn)
  - [conectawifi.sh](#conectawifish--conectar-a-una-red-wifi)
  - [vpn.sh](#vpnsh--enrutamiento-policy-based-routing-vía-tabla-137)
  - [CompartirVPN.txt](#compartirvpntxt--compartir-una-vpn-con-otra-red-nat--forwarding)
  - [errores.sh](#erroressh--reinicio-de-emergencia-de-la-red)
  - [restart.sh](#restartsh--reinicio-simple-del-servicio-de-red)
  - [ssh_.txt / trace](#ssh_txt-y-trace--notas-y-plantillas-auxiliares)
- [Flujo de trabajo recomendado](#flujo-de-trabajo-recomendado)
- [Chuleta de comandos `ip` / `ifconfig` incluida en el README original](#chuleta-de-comandos-ip--ifconfig-incluida-en-el-readme-original)
- [Preguntas frecuentes](#preguntas-frecuentes)
- [Autor y créditos](#autor-y-créditos)

---

### route

El repositorio agrupa scripts sueltos —sin instalador ni dependencias externas— que cubren el ciclo de vida habitual de la configuración de red en un servidor o equipo Linux (especialmente Debian/Ubuntu):

1. **Enrutamiento** — añadir rutas estáticas hacia otras redes/VPNs (`route.sh`, `CompartirVPN.txt`) o hacer *policy-based routing* por tabla de rutas (`vpn.sh`).
2. **Multihoming / IP aliasing** — asignar varias IPs o rangos a la misma interfaz física (`ipotrasredes.sh`).
3. **Diagnóstico de interfaces y rutas** — listar IP, gateway, tabla de rutas y vecinos IPv6 (`verinterfaces.sh`, `verrutas.sh`, `vecinos.sh`).
4. **Recuperación de red** — reiniciar el servicio de red o forzar el reinicio de todas las interfaces cuando algo se queda "colgado" (`errores.sh`, `restart.sh`, `verinterfaces2.sh`).
5. **Conectividad Wi-Fi** — escanear y conectar a una red inalámbrica desde línea de comandos (`conectawifi.sh`).
6. **Monitorización de ruta hacia un destino** — traceroute en bucle con información de ASN/país por salto y alerta visual de cambios de ruta (`traceroute.sh`).
7. **Plantillas de configuración** — ejemplos de `/etc/network/interfaces` (`interfaces`, `interfaces2`) y notas sobre SSH (`ssh_.txt`).

---

### Requisitos previos

| Herramienta | Función | Instalación (Debian/Ubuntu) |
|---|---|---|
| `iproute2` (`ip`) | Gestión moderna de interfaces, rutas y vecinos | Viene preinstalado; si no, `sudo apt install iproute2` |
| `net-tools` (`ifconfig`, `route`, `arp`) | Comandos "clásicos" de red usados en varios scripts | `sudo apt install net-tools` |
| `traceroute` | Traza de ruta hacia un destino (usado por `traceroute.sh`) | `sudo apt install traceroute` |
| `whois` | Consulta de ASN/titular por salto en `traceroute.sh` | `sudo apt install whois` |
| `network-manager` (`nmcli`) / `wireless-tools` (`iwconfig`, `iwlist`) | Gestión de Wi-Fi en `conectawifi.sh` | `sudo apt install network-manager wireless-tools` |
| `isc-dhcp-client` (`dhclient`) | Renovación de IP por DHCP | `sudo apt install isc-dhcp-client` |
| `iptables` | NAT/forwarding en `CompartirVPN.txt` | `sudo apt install iptables` |
| `netdiscover` | Descubrimiento de hosts por ARP (mencionado en el README original) | `sudo apt install netdiscover` |
| Privilegios `root`/`sudo` | Necesarios para casi todos los scripts | — |

---

### Estructura del repositorio

```
route/
├── README.md              # Chuleta de comandos ip/ifconfig/route (documento original)
├── route.png               # Logo del proyecto
│
├── route.sh                 # Añade rutas estáticas hacia 172.16.0.0/12 y 10.0.0.0/8
├── ipotrasredes.sh           # Asigna IPs adicionales (alias) sobre la misma interfaz
├── vpn.sh                     # Policy-based routing: crea tabla de rutas 137 basada en la IP pública
├── CompartirVPN.txt            # Notas: enrutar tráfico de una red a través de un túnel VPN (NAT + forwarding)
│
├── verinterfaces.sh             # Muestra IP y gateway de eth0/eth1/eth2
├── verinterfaces2.sh             # Activa interfaces caídas, pide IP por DHCP y reinicia red
├── verrutas.sh                    # Muestra la tabla de rutas IPv4 e IPv6
├── vecinos.sh                      # Muestra la tabla de vecinos IPv6 (equivalente a ARP en IPv6)
│
├── traceroute.sh                    # Monitor de traceroute en bucle con ASN/país y alertas de cambio de ruta
├── conectawifi.sh                    # Escanea y conecta a una red Wi-Fi por nmcli
│
├── errores.sh                         # "Botón de pánico": limpia loopback y reinicia toda la red
├── restart.sh                          # Reinicio simple del servicio networking
│
├── interfaces                          # Ejemplo de fichero /etc/network/interfaces
├── interfaces2                          # Segunda plantilla de /etc/network/interfaces
├── ssh_.txt                              # Notas/comandos relacionados con SSH
└── trace                                  # Fichero de notas/ejemplo relacionado con traceroute
```

---

## Tabla resumen de scripts

| Script | Categoría | Root/sudo | Qué hace en una frase | Modifica el sistema |
|---|---|---|---|---|
| **route.sh** | Enrutamiento | Sí | Añade rutas estáticas a `172.16.0.0/12` y `10.0.0.0/8` vía un gateway y muestra la tabla de rutas antes/después | Sí |
| **ipotrasredes.sh** | Enrutamiento / IP aliasing | Sí | Asigna direcciones IP adicionales (`10.0.0.1/8`, `172.16.0.1/12`) como alias sobre `eth0` | Sí |
| **vpn.sh** | Enrutamiento avanzado | Sí | Crea una tabla de rutas propia (137) para enrutar el tráfico de la IP pública actual por una ruta específica | Sí |
| **CompartirVPN.txt** | Enrutamiento / NAT | Sí | Guía de comandos para reenviar tráfico de una LAN a través de un túnel VPN (`tun0`) con `iptables MASQUERADE` | Sí |
| **verinterfaces.sh** | Diagnóstico | No | Imprime la IP y el gateway configurados en `eth0`, `eth1` y `eth2` | No |
| **verinterfaces2.sh** | Diagnóstico / recuperación | Sí | Muestra el estado de los enlaces, activa `eth1/eth2/eth3/wlan0`, pide IP por DHCP y reinicia el servicio de red | Sí |
| **verrutas.sh** | Diagnóstico | No | Muestra la tabla de rutas del sistema en formato clásico (`route -A inet -A inet6`) | No |
| **vecinos.sh** | Diagnóstico | No | Muestra la tabla de vecinos IPv6 (equivalente a la caché ARP en IPv6) | No |
| **traceroute.sh** | Diagnóstico / monitorización | No (whois sin sudo) | Lanza un traceroute TCP en bucle contra un destino, resuelve ASN/país de cada salto y resalta en rojo los saltos que cambian respecto a la traza anterior | No |
| **conectawifi.sh** | Conectividad | Sí | Activa la interfaz Wi-Fi, escanea redes y se conecta a un SSID con contraseña vía `nmcli` | Sí |
| **errores.sh** | Recuperación de emergencia | Sí | Limpia la IP del loopback, baja y sube todas las interfaces y reinicia el servicio de red | Sí |
| **restart.sh** | Recuperación | Sí | Reinicia el servicio `networking` mediante el script de init clásico | Sí |
| **interfaces / interfaces2** | Plantilla de configuración | — | Ejemplos de fichero `/etc/network/interfaces` para configurar interfaces de forma persistente | Referencia |
| **ssh_.txt** | Notas | — | Apuntes/comandos relacionados con SSH | Referencia |
| **trace** | Notas | — | Fichero de ejemplo/notas relacionado con trazas de red | Referencia |

---

## Detalle de cada script

### `route.sh` — Añadir rutas estáticas a otras redes

Script de referencia para **enrutar tráfico hacia redes privadas** (RFC 1918) a través de un gateway concreto de la LAN. Es el script que da nombre al repositorio.

```bash
sh route.sh
```

```bash
ip route show
route add -net 172.16.0.0/12 gw 192.168.1.1 dev eth0
route add -net 10.0.0.0/8 gw 192.168.1.1 dev eth0
ip route list
```

| Paso | Qué hace |
|---|---|
| `ip route show` | Muestra la tabla de rutas actual antes de modificarla |
| `route add -net 172.16.0.0/12 gw 192.168.1.1 dev eth0` | Añade una ruta hacia todo el rango `172.16.0.0/12` (uso típico: redes Docker/K8s o LAN secundaria) a través del gateway `192.168.1.1` |
| `route add -net 10.0.0.0/8 gw 192.168.1.1 dev eth0` | Añade una ruta hacia el rango `10.0.0.0/8` (uso típico: red corporativa/VPN) por el mismo gateway |
| `ip route list` | Confirma que las rutas se añadieron correctamente |

> Los valores `eth0`, `192.168.1.1`, `172.16.0.0/12` y `10.0.0.0/8` son un ejemplo: sustitúyelos por tu interfaz, gateway y redes reales.

---

### `ipotrasredes.sh` — IP alias: múltiples redes en la misma interfaz

Permite que una única interfaz física atienda a **varias subredes** asignándole direcciones IP adicionales con etiqueta (`label`), técnica clásica de *IP aliasing*.

```bash
sh ipotrasredes.sh
```

```bash
ip addr add 10.0.0.1/8 dev eth0 label eth0:1
ip addr add 172.16.0.1/12 dev eth0 label eth0:2
```

El script incluye, comentadas, las líneas para cambiar el gateway por defecto si se necesitara:

```bash
#route add default gw 10.0.0.1 eth0
#route add default gw 192.168.1.1 eth0
```

---

### `interfaces` e `interfaces2` — Plantillas de configuración `/etc/network/interfaces`

Dos ficheros de ejemplo (no scripts ejecutables) con la sintaxis del gestor de red clásico de Debian/Ubuntu (`ifupdown`), útiles como plantilla para configurar interfaces de forma persistente entre reinicios, en lugar de usar comandos `ip`/`ifconfig` que se pierden al reiniciar.

**Uso:** copiar el contenido adaptado a `/etc/network/interfaces` y reiniciar el servicio de red (ver `restart.sh`).

---

### `verinterfaces.sh` — Resumen de IP y gateway por interfaz

Script de solo lectura (no requiere privilegios) que extrae y muestra de forma legible la IP y el gateway configurados para tres interfaces predefinidas.

```bash
sh verinterfaces.sh
```

| Comando interno | Propósito |
|---|---|
| `ip -o -4 addr list eth0 \| awk '{print $4}' \| cut -d/ -f1` | Extrae la IPv4 configurada en `eth0` |
| `ip route list dev eth0 \| awk '{print $1}' \| tail -1 \| cut -d'/' -f1` | Extrae el gateway/ruta asociado a `eth0` |

El mismo patrón se repite para `eth1` y `eth2`. Salida de ejemplo:

```
Interface Eth0: ip: 192.168.1.50, Gateway 192.168.1.0
```

> Si tus interfaces tienen otro nombre (p. ej. `enp3s0`, `wlan0`), habrá que editar el script.

---

### `verinterfaces2.sh` — Activar interfaces y relanzar red

Script de **recuperación rápida**: revisa el estado de los enlaces, levanta las interfaces que estén caídas (incluyendo Wi-Fi), solicita IP por DHCP en las interfaces cableadas y finalmente reinicia el servicio de red.

```bash
sudo sh verinterfaces2.sh
```

| Bloque | Comandos | Propósito |
|---|---|---|
| Diagnóstico | `ip link show`, `ifconfig -a` | Ver el estado (UP/DOWN) de todas las interfaces |
| Activación | `sudo ip link set eth1/eth2/eth3/wlan0 up` | Sube manualmente las interfaces indicadas |
| DHCP | `sudo dhclient eth1/eth2/eth3` | Solicita una IP por DHCP en cada interfaz |
| Reinicio | `sudo systemctl restart networking` | Reinicia el servicio de red para aplicar cambios |

---

### `verrutas.sh` — Ver tabla de rutas (IPv4/IPv6)

Un envoltorio de una línea sobre el comando clásico `route`, mostrando de golpe las rutas IPv4 e IPv6.

```bash
sh verrutas.sh
```

```bash
route -A inet -A inet6
```

---

### `vecinos.sh` — Tabla de vecinos IPv6 (NDP)

Equivalente en IPv6 a consultar la caché ARP: muestra los hosts vecinos detectados vía **NDP (Neighbor Discovery Protocol)**.

```bash
sh vecinos.sh
```

```bash
ip -6 neigh
```

---

### `traceroute.sh` — Monitor de traceroute con whois/ASN

El script más elaborado del repositorio. Traza continuamente la ruta TCP hacia un destino (por defecto `hackingyseguridad.com:443`), enriquece cada salto con su **ASN, nombre del AS y país** vía `whois`, y **resalta en rojo** los saltos cuya IP cambia respecto a la traza anterior — útil para detectar cambios de ruta, caídas de un proveedor intermedio o redirecciones de tráfico sospechosas.

```bash
sh traceroute.sh
```

| Función interna | Propósito |
|---|---|
| `print_header()` | Limpia la pantalla y dibuja la cabecera de la tabla (Hop / IP / ASN / AS Nombre / País) |
| `get_asn_info()` | Consulta `whois` sobre una IP y extrae `origin`/`OriginAS`, `descr` y `country` |
| `run_trace()` | Ejecuta `traceroute -T -p 443 -n $DEST` y extrae hop e IP de cada línea |
| `compare_and_print()` | Imprime cada salto; si la IP de ese hop difiere de la traza anterior, la pinta en **rojo** |
| Bucle principal | Repite el proceso cada ~11 segundos indefinidamente (`Ctrl+C` para detener) |

**Personalización:** edita las variables al inicio del script para cambiar el destino:

```bash
DEST="hackingyseguridad.com"
PORT=443
```

---

### `conectawifi.sh` — Conectar a una red Wi-Fi

Automatiza el ciclo completo de conexión Wi-Fi por línea de comandos: revisión de adaptadores, activación de la interfaz, escaneo de redes cercanas y conexión con contraseña vía `nmcli`.

```bash
sudo sh conectawifi.sh
```

| Paso | Comando | Propósito |
|---|---|---|
| 1 | `iwconfig` / `ifconfig` | Listar adaptadores inalámbricos disponibles |
| 2 | `ifconfig wlan0 up` / `ifup wlan0` | Activar la interfaz Wi-Fi |
| 3 | `iwlist wlan0 scanning` | Escanear redes visibles (modo clásico) |
| 4 | `nmcli device wifi` | Listar redes visibles (NetworkManager) |
| 5 | `nmcli d wifi connect hackingyseguridad password 12345 iface wlan0` | Conectarse a la red indicada |
| 6 | `dhclient wlan0` | Solicitar IP por DHCP |
| 7 | `iwconfig wlan0` | Confirmar el estado final de la conexión |

> ⚠️ El SSID (`hackingyseguridad`) y la contraseña (`12345`) están **hardcodeados como ejemplo** — sustitúyelos por los de tu propia red antes de ejecutar.

---

### `vpn.sh` — Enrutamiento *policy-based* vía tabla 137

Crea una **tabla de rutas personalizada** (`137`) que enruta el tráfico originado desde la IP pública actual del equipo por una ruta específica — un patrón típico para escenarios multi-WAN o VPN donde se quiere que el tráfico "de vuelta" salga siempre por la misma interfaz/gateway por la que entró.

```bash
sudo sh vpn.sh
```

```bash
myip=$(curl ifconfig.me -sk)
ip rule add table 137 from ${myip}
baseip=$(echo ${myip} | cut -d"." -f1-3)
ip route add table 137 to ${baseip}.0/24 dev eth0
ip route add table 137 default via ${baseip}.1
```

| Paso | Qué hace |
|---|---|
| `curl ifconfig.me -sk` | Obtiene la IP pública actual del equipo |
| `ip rule add table 137 from $myip` | Crea una regla: "el tráfico que salga con origen esta IP usa la tabla 137" |
| `ip route add table 137 to $baseip.0/24 dev eth0` | En la tabla 137, la red local `/24` se alcanza directamente por `eth0` |
| `ip route add table 137 default via $baseip.1` | En la tabla 137, el resto del tráfico sale por el `.1` de esa misma red (gateway) |

---

### `CompartirVPN.txt` — Compartir una VPN con otra red (NAT + forwarding)

No es un script ejecutable, sino una **guía de comandos comentada** para dos escenarios de red conectados entre sí (llamados "A" y "B" en el propio fichero): enrutar el tráfico de la red A hacia B, activar el reenvío de paquetes en B, y enmascarar (NAT) ese tráfico al salir por un túnel VPN (`tun0`).

| Bloque | Comando | Propósito |
|---|---|---|
| Enrutamiento (en A) | `ip r a 192.168.1.0/24 via 192.168.1.252 dev eth0` | En el equipo A, enruta el tráfico hacia `192.168.1.0/24` a través de B (`192.168.1.252`) |
| IP Forwarding (en B) | `sysctl net.ipv4.conf.all.forwarding=1` | Activa el reenvío de paquetes IPv4 en el equipo B (persistente vía `/etc/sysctl.conf`) |
| Verificación | `iptables -L FORWARD -nv` | Comprueba las reglas de la cadena `FORWARD` |
| NAT/Masquerade | `iptables -t nat -I POSTROUTING -o tun0 -j MASQUERADE` | Enmascara el tráfico saliente por `tun0` para que salga con la IP del túnel VPN |

---

### `errores.sh` — Reinicio de emergencia de la red

El "botón de pánico" del repositorio: limpia el loopback, tira y vuelve a levantar **todas** las interfaces configuradas en `ifupdown`, y reinicia el servicio de red. Pensado para cuando la red del sistema queda en un estado inconsistente.

```bash
sudo sh errores.sh
```

```bash
sudo ip addr flush dev lo
sudo ifdown --all
sudo ifup --all
sudo service networking restart
```

---

### `restart.sh` — Reinicio simple del servicio de red

Versión mínima de reinicio de red, usando el script de inicio clásico de SysV en lugar de `systemctl`.

```bash
sudo sh restart.sh
```

```bash
/etc/init.d/networking restart
```

---

### `ssh_.txt` y `trace` — Notas y plantillas auxiliares

Ficheros de texto sin formato ejecutable, con **apuntes de referencia** del autor: `ssh_.txt` recoge comandos/notas relacionados con SSH, y `trace` contiene notas o un ejemplo de salida relacionado con trazas de red. Se incluyen como material de consulta rápida más que como herramientas.

---

## Flujo de trabajo recomendado

1. **Diagnóstico inicial** — antes de tocar nada, revisa el estado actual con `verinterfaces.sh` (IP/gateway), `verrutas.sh` (tabla de rutas) y, si trabajas en IPv6, `vecinos.sh`.
2. **Configurar acceso a otra red** — si necesitas llegar a una red privada remota (VPN, LAN secundaria), usa `route.sh` como plantilla y ajusta el gateway/rango a tu caso.
3. **Multihoming** — si la misma interfaz debe atender a varias subredes, usa `ipotrasredes.sh` para añadir los alias de IP.
4. **Escenarios VPN avanzados** — para separar tráfico por origen (policy-based routing) usa `vpn.sh`; para compartir una VPN con otra red completa (NAT), sigue la guía de `CompartirVPN.txt`.
5. **Conectividad Wi-Fi** — si el equipo se conecta por Wi-Fi, usa `conectawifi.sh` (ajustando SSID/contraseña).
6. **Monitorización continua** — deja `traceroute.sh` corriendo en una terminal para vigilar cambios de ruta hacia un destino crítico.
7. **Si algo falla** — `verinterfaces2.sh` para relevantar interfaces y pedir IP por DHCP; `errores.sh` o `restart.sh` como último recurso para reiniciar la pila de red completa.

---

## Chuleta de comandos `ip` / `ifconfig` incluida en el README original

El `README.md` original del repositorio no describe los scripts, sino que funciona como una **chuleta (cheatsheet)** de comandos de red en Linux, comparando la sintaxis clásica (`ifconfig`, `route`, `arp`) con la moderna (`ip`). Se resume aquí a modo de referencia:

| Tarea | Comando clásico | Comando moderno (`ip`) |
|---|---|---|
| Ver interfaces e IP | `ifconfig` | `ip addr show` / `ip link show` |
| Asignar IP a una interfaz | `ifconfig eth1 10.1.1.2` | `ip addr add 10.1.1.2/16 dev eth1` |
| Activar una interfaz | `ifconfig eth0 up` | `ip link set eth0 up` |
| Desactivar una interfaz | `ifconfig eth0 down` | `ip link set eth0 down` |
| Asignar IP (forma completa) | `ifconfig eth0 192.168.0.77 netmask 255.255.255.0 broadcast 192.168.0.255` | `ip addr add 192.168.0.77/24 broadcast 192.168.0.255 dev eth0` |
| Borrar una IP | — | `ip addr del 192.168.0.77/24 dev eth0` |
| Crear alias de interfaz | `ifconfig eth0:1 10.0.0.1/8` | `ip addr add 10.0.0.1/8 dev eth0 label eth0:1` |
| Entrada ARP estática | `arp -i eth0 -s 192.168.0.1 00:11:22:33:44:55` | `ip neigh add 192.168.0.1 lladdr 00:11:22:33:44:55 nud permanent dev eth0` |
| Desactivar ARP en una interfaz | `ifconfig -arp eth0` | `ip link set dev eth0 arp off` |
| Ver tabla de rutas | `route` | `ip route show` |
| Ver por qué interfaz saldría un paquete | — | `ip route get 192.168.88.77` |
| Añadir ruta (por interfaz) | `route add -net 192.168.3.0/24 dev eth3` | `ip route add 192.168.3.0/24 dev eth3` |
| Borrar ruta | `route del -net 192.168.3.0/24 dev eth3` | `ip route del 192.168.3.0/24 dev eth3` |
| Añadir ruta (vía gateway) | `route add -net 192.168.4.0/24 gw 192.168.4.1` | `ip route add 192.168.4.0/24 via 192.168.4.1` |
| Ver caché ARP | — | `ip neighbor show` / `ip neighbor show dev eth0` |
| Descubrir hosts activos por ARP | `netdiscover` | — |

---


---

## Autor y créditos

- [www.hackingyseguridad.com](http://www.hackingyseguridad.com/)
- [@antonio_taboada](https://twitter.com/antonio_taboada)
- [github.com/hackingyseguridad/route](https://github.com/hackingyseguridad/route)
- **Temas del repositorio:** `linux`, `router`, `add`, `redes`, `hackingyseguridad`




