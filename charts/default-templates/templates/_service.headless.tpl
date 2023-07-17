{{- define "chart.service.headless" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.statefulset.serviceName }}
  labels: {{- include "chart.labels" . | nindent 4 }}
  {{- if .Values.service.annotations }}
  annotations: {{- toYaml .Values.service.annotations | nindent 4 }}
  {{- end }}
spec:
  type: ClusterIP
  clusterIP: None
  ports:
  {{- range $port := .Values.service.ports }}
    - port: {{ $port.port }}
      targetPort: {{ $port.targetPort | default $port.port }}
      protocol: {{ $port.protocol | default "TCP" }}
      name: {{ $port.name }}
  {{- end }}
  selector: {{- include "chart.matchLabels" . | nindent 4 }}
{{- end }}