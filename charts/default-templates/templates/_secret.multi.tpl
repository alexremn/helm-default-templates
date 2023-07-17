{{- define "chart.secret.multi" -}}
{{- range $secret, $val := .Values.secrets }}
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: {{ $secret }}
  labels: {{- include "chart.labels" $ | nindent 4 }}
  {{- if $.Values.secrets.annotations }}
  annotations: {{- toYaml $.Values.secrets.annotations | nindent 4 }}
  {{- end }}
data:
{{- range $key, $value := .values }}
{{- printf "%s: %s" $key ($value | toString | b64enc | quote) | nindent 2 }}
{{- end }}
{{- with .tplvalues }}
{{ tpl . $ | nindent 2 }}
{{- end }}
---
{{- end }}
{{- end }}