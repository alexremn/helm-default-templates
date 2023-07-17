{{- define "chart.secret" -}}
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: {{ if .Values.secret.name }}{{ .Values.secret.name }}{{else}}{{ template "chart.fullname" . }}{{ end }}
  labels: {{- include "chart.labels" . | nindent 4 }}
  {{- if .Values.secret.annotations }}
  annotations: {{- toYaml .Values.secret.annotations | nindent 4 }}
  {{- end }}
data:
{{- range $key, $value := .Values.secret.values }}
{{- printf "%s: %s" $key ($value | toString | b64enc | quote) | nindent 2 }}
{{- end }}
{{- with .Values.secret.tplvalues }}
{{ tpl . $ | nindent 2 }}
{{- end }}
{{- end }}