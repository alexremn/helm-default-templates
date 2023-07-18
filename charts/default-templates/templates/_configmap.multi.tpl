{{- define "chart.configmap.multi" -}}
{{- range $name, $val := .Values.configmaps }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $name }}
  labels: {{- include "chart.labels" $ | nindent 4 }}
  {{- if $.Values.configmaps.annotations }}
  annotations: {{- toYaml $.Values.configmaps.annotations | nindent 4 }}
  {{- end }}
data:
{{- range $key, $value := $val }}
{{- printf "%s: %s" $key ($value | toString | quote) | nindent 2 }}
{{- end }}
---
{{- end }}
{{- end }}