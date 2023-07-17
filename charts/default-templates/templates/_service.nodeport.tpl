{{- define "chart.service.nodeport" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ template "chart.fullname" . }}-nodeport
  labels: {{- include "chart.labels" . | nindent 4 }}
  {{- if .Values.service.annotations }}
  annotations: {{- toYaml .Values.service.annotations | nindent 4 }}
  {{- end }}
spec:
  type: NodePort
  ports:
  {{- range $port := .Values.service.ports }}
    - port: {{ $port.port }}
      targetPort: {{ $port.targetPort | default $port.port }}
      protocol: {{ $port.protocol | default "TCP" }}
      {{- if $port.nodePort }}
      nodePort: {{ $port.nodePort }}
      {{- end }}
  {{- end }}
  selector: {{- include "chart.matchLabels" . | nindent 4 }}
{{- end }}