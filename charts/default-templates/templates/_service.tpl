{{- define "chart.service" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ template "chart.fullname" . }}
  labels: {{- include "chart.labels" . | nindent 4 }}
  {{- if .Values.service.annotations }}
  annotations: {{- toYaml .Values.service.annotations | nindent 4 }}
  {{- end }}
spec:
  type: {{ .Values.service.type | default "ClusterIP" }}
{{- if eq "ExternalName" ( .Values.service.type | default "ClusterIP" ) }}
  externalName: {{ tpl .Values.service.externalName . }}
{{- else }}
  ports:
{{- range $port := .Values.service.ports }}
    - port: {{ $port.port }}
      targetPort: {{ $port.targetPort | default $port.port }}
      protocol: {{ $port.protocol | default "TCP" }}
      name: {{ $port.name }}
{{- end }}
  selector: {{- include "chart.matchLabels" . | nindent 4 }}
{{- end }}
{{- end }}