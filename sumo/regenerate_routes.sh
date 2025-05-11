#!/bin/bash
cd /d/TrAD-Quito/sumo || exit
echo "Regenerando rutas para todas las densidades..."

declare -A rates=(
  [40]=0.035
  [60]=0.052
  [80]=0.070
  [100]=0.087
  [120]=0.105
  [140]=0.122
  [160]=0.140
)

for DENS in "${!rates[@]}"; do
  echo "Densidad: $DENS veh/km (${rates[$DENS]} vps)"
  python "$SUMO_HOME/tools/randomTrips.py" \
    -n input/simon_bolivar.net.xml \
    -r input/simon_bolivar_${DENS}.rou.xml \
    -e 1000 \
    --prefix v${DENS}_ \
    --trip-attributes 'departLane="best" departSpeed="max" departPos="random"' \
    --seed 42 \
    --insertion-rate "${rates[$DENS]}" \
    --fringe-factor 3 \
    --min-distance 800 \
    --validate
done

echo "¡Rutas regeneradas correctamente!"
