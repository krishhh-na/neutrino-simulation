#!/bin/bash
start_ns=$(date +%s%N)           # inicio en nanosegundos
prev_ns=$start_ns                 # para promediar intervalos
sum_interval_ns=0                 # suma de intervalos
count=0

for i in $(seq -w 0001 1000); do
  now="$(date -Iseconds)"         # tiempo ISO 8601
  rnd=$((RANDOM % 11))            # 0..10

  printf "Time: %s\nNeutrinos detected: %d\n" "$now" "$rnd" > "$i.txt"

  # intervalo desde el archivo anterior
  now_ns=$(date +%s%N)
  if [ "$i" != "0001" ]; then
    sum_interval_ns=$((sum_interval_ns + (now_ns - prev_ns)))
    count=$((count + 1))
  fi
  prev_ns=$now_ns
done

# concatenar todos en un solo archivo
cat *.txt > results.txt

# métricas de performance
end_ns=$(date +%s%N)
total_s=$(awk "BEGIN {printf \"%.3f\", ($end_ns - $start_ns)/1e9}")

avg_interval_ms="N/A"
if [ $count -gt 0 ]; then
  avg_interval_ms=$(awk "BEGIN {printf \"%.3f\", $sum_interval_ns/($count*1e6)}")
fi

{
  echo "Tiempo total: ${total_s} s"
  echo "Intervalo promedio entre archivos: ${avg_interval_ms} ms"
  echo "Archivos generados: 1000"
} > performance.txt
