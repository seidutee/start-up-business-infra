{{- $quoted := list }}
{{- range $i, $t := .targets }}
  {{- $quoted = append $quoted (printf "\"%s\"" $t) }}
{{- end }}

global:
  scrape_interval: 15s

rule_files:
  - "/etc/prometheus/alert.rules.yml"

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'my_app'
    static_configs:
      - targets: [{{ join ", " $quoted }}]

