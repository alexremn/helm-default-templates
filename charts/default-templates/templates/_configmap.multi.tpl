{{- define "chart.configmap.multi" -}}
{{- range $configmap, $val := .Values.configmaps }}
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $configmap }}
  labels: {{- include "chart.labels" $ | nindent 4 }}
  {{- if $.Values.configmaps.annotations }}
  annotations: {{- toYaml $.Values.configmaps.annotations | nindent 4 }}
  {{- end }}
data:
{{- range $key, $value := .values }}
{{- printf "%s: %s" $key ($value | toString | quote) | nindent 2 }}
{{- end }}
{{- with .tplvalues }}
{{ tpl . $ | nindent 2 }}
{{- end }}
---
{{- end }}
{{- end }}