﻿--
--	Proculas
--	Created by Clorell/Keruni of Argent Dawn [US]
--	$Id$
--

local L = LibStub("AceLocale-3.0"):NewLocale("Proculas", "esES")
if not L then return end

L["ABOUT_CMD"] = "Acerca de" -- Needs review
L["ABOUT_CMD_DESC"] = "Acerca de Proculas (/proculas about)" -- Needs review
L["ADD"] = "Añadir" -- Needs review
L["ADD_SOUND"] = "Añadir sonido" -- Needs review
L["ALTCLICK2RESET"] = "Alt-botón izquierdo del ratón para reiniciar." -- Needs review
L["ANNOUNCE_PROC"] = "Anuncio de activación" -- Needs review
L["ANNOUNCE_PROC_DESC"] = "Mostrar mensaje para esta activación." -- Needs review
L["BAR_FONT"] = "Tipografía en las barras" -- Needs review
L["BAR_FONT_SIZE"] = "Tamaño de la tipografía en barra." -- Needs review
L["BAR_HEIGHT"] = "Altura de barra" -- Needs review
L["BAR_OPTIONS"] = "Opciones de barras" -- Needs review
L["BAR_TEXTURE"] = "Textura de barras" -- Needs review
L["BAR_WIDTH"] = "Ancho de barra" -- Needs review
L["COLOR"] = "Color" -- Needs review
L["COLOR_DESC"] = "Seleccionar el color del mensaje." -- Needs review
L["CONFIG_COOLDOWNS"] = "Opciones de reutilización." -- Needs review
L["CONFIG_MESSAGES"] = "Mensajes" -- Needs review
L["CONFIG_MESSAGES_DESC"] = "Opciones de mensaje" -- Needs review
L["CONFIG_PROC_MESSAGE"] = "Configurar mensajes cuando haya activaciones." -- Needs review
L["CONFIG_PROC_SOUND"] = "Configurar las opciones de sonido de Proculas." -- Needs review
L["CONFIG_PROC_STATS"] = "Estadísticas de activaciones."
L["CONFIG_PROC_STATS_DESC"] = "Opciones de estadísticas de activaciones" -- Needs review
L["CONFIG_SOUND"] = "Opciones de sonido" -- Needs review
L["CONFIGURE_CMD"] = "Configurar" -- Needs review
L["CONFIGURE_CMD_DESC"] = "Abrir el diálogo de configuración (/proculas config)" -- Needs review
L["COOLDOWN"] = "Reutilización" -- Needs review
L["COOLDOWN_OPTIONS"] = "Opciones de reutilización" -- Needs review
L["COOLDOWN_SETTINGS"] = "Opciones de reutilización" -- Needs review
L["COOLDOWN_TIME"] = "Tiempo de reutilización" -- Needs review
L["COOLDOWN_TIME_DESC"] = "Fijar o cambiar el tiempo de reutilización (en segundos)." -- Needs review
L["CUSTOM_MESSAGE"] = "Mensaje particular" -- Needs review
L["CUSTOM_MESSAGE_DESC"] = "Marcar para permitir el uso de un mensaje en particular." -- Needs review
L["CUSTOMSOUND_LOCATION_DESC"] = "Ejemplo: ruta/a/archivo" -- Needs review
L["CUSTOMSOUND_SELECT_SOUND_DESC"] = "Elegir el sonido personalizado para borrar" -- Needs review
L["DEBUGVER_CMD"] = "Versión de depuración" -- Needs review
L["DEFAULT_PROC_MESSAGE"] = "%s activado" -- Needs review
L["DELETE"] = "Borrar" -- Needs review
L["DELETE_SOUND"] = "Borrar sonido" -- Needs review
L["ENABLE"] = "Permitir" -- Needs review
L["ENABLE_COOLDOWN"] = "Permitir reutilización" -- Needs review
L["ENABLE_COOLDOWN_DESC"] = "Marcar para mostrar esta activación en la lista de reutilización." -- Needs review
L["ENABLE_COOLDOWNS"] = "Permitir reutilizaciones." -- Needs review
L["ENABLE_COOLDOWNS_DESC"] = "Permitir/Impedir mostrar tiempos de reutilización de lo activado en el marco de reutilizaciones." -- Needs review
L["ENABLE_DESC"] = "Quitar la marca para inhabilitar esta activación. No será registrada en las estadísticas." -- Needs review
L["ENABLE_POSTING"] = "¿Permitir mensajes de activación?" -- Needs review
L["END_COLOR"] = "Color final" -- Needs review
L["END_COLOR_DESC"] = "Elija el color de la barra de reutilización en el que se desvanecerá." -- Needs review
L["FLASH_BAR"] = "Barra parpadeante" -- Needs review
L["FLASH_BAR_DESC"] = "Quite la marca para inhabilitar el parpadeo de las barras de reutilización." -- Needs review
L["FLASH_SCREEN"] = "Parpadeo del borde de la pantalla" -- Needs review
L["FLASH_SCREEN_DESC"] = "Parpadea el borde de la pantalla cuando haya activaciones." -- Needs review
L["GENERAL_SETTINGS"] = "Opciones generales" -- Needs review
L["GROW_UPWARDS"] = "Desplazarse hacia arriba" -- Needs review
L["HIDEMINIMAPBUTTON"] = "Ocultar botón del minimapa" -- Needs review
L["LOCATION"] = "Sitio" -- Needs review
L["MESSAGE"] = "Mensaje" -- Needs review
L["MESSAGE_DESC"] = "Mensaje a mostrar. Utilizar %s como el nombre de la activación." -- Needs review
L["MINIMAPBUTTONSETTINGS"] = "Opciones del botón del minimapa" -- Needs review
L["MOVABLEFRAME"] = "Marco móvil" -- Needs review
L["NA"] = "No aplicable" -- Needs review
L["NAME"] = "Nombre" -- Needs review
L["NEW_CUSTOM_SOUND"] = "Sonido nuevo personalizado" -- Needs review
L["POST_PROCS"] = "Mensajes tras la activación" -- Needs review
L["POST_PROCS_DESC"] = "Marcar para permitir mensajes de activación" -- Needs review
L["PPM"] = "PPM" -- Needs review
L["PROC"] = "Activación" -- Needs review
L["PROC_ANNOUNCEMENTS"] = "Anuncios de activaciones" -- Needs review
L["PROC_MESSAGE"] = "Mensaje de activación" -- Needs review
L["PROCS"] = "Activaciones" -- Needs review
L["PROC_SETTINGS"] = "Opciones en la activación" -- Needs review
L["PROC_SETTINGS_DESC"] = "Configurar opciones para activaciones individuales." -- Needs review
L["Proculas"] = "Proculas" -- Needs review
L["PROFILES"] = "Perfiles" -- Needs review
L["RC2OPENOPTIONS"] = "Dar con el botón derecho para configurar." -- Needs review
L["RESET_PROC_STATS"] = "Reiniciar estadísticas de activaciones" -- Needs review
L["RESET_PROC_STATS_DESC"] = "Reiniciar todas las estadísticas de activaciones grabadas." -- Needs review
L["SCREEN_EFFECTS"] = "Efectos de pantalla" -- Needs review
L["SELECT_PROC"] = "Seleccionar activación" -- Needs review
L["SELECT_PROC_DESC"] = "Elegir activación para configurar." -- Needs review
L["SELECT_SOUND"] = "Elegir sonido" -- Needs review
L["SHAKE_SCREEN"] = "Menear pantalla" -- Needs review
L["SHAKE_SCREEN_DESC"] = "Menea la pantalla cuando haya activaciones." -- Needs review
L["SHOWCOOLDOWNS"] = "Mostrar reutilizaciones" -- Needs review
L["SOUND_SETTINGS"] = "Opciones de sonido" -- Needs review
L["SOUND_TO_PLAY"] = "Sonido a tocar" -- Needs review
L["START_COLOR"] = "Color inicial" -- Needs review
L["START_COLOR_DESC"] = "Elija el color inicial de la barra de reutilización" -- Needs review
L["TOTAL_PROCS"] = "Activaciones totales" -- Needs review
L["UPDATE_COOLDOWN"] = "Actualizar reutilización" -- Needs review
L["UPDATE_COOLDOWN_DESC"] = "Quitar marca para evitar que Proculas cambie el tiempo de reutilización." -- Needs review
L["UPTIME"] = "Duración" -- Needs review
L["WHERE_TO_POST"] = "¿Dónde deberían aparecer los mensajes de activación?" -- Needs review
