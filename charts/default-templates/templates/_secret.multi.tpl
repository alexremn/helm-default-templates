{{- define "chart.secret.multi" -}}
{{- range $name, $val := .Values.secrets }}
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: {{ $name }}
  labels: {{- include "chart.labels" $ | nindent 4 }}
  {{- if $.Values.secrets.annotations }}
  annotations: {{- toYaml $.Values.secrets.annotations | nindent 4 }}
  {{- end }}
data:
{{- range $key, $value := $val }}
{{- printf "%s: %s" $key ($value | toString | b64enc | quote) | nindent 2 }}
{{- end }}
---
{{- end }}
{{- end }}