{{- define "chart.hpa" -}}
apiVersion: {{ include "common.capabilities.hpa.apiVersion" . }}
kind: HorizontalPodAutoscaler 
metadata:
  name: {{ template "chart.fullname" . }}
  labels: {{- include "chart.labels" . | nindent 4 }}
spec: 
  maxReplicas: {{ .Values.hpa.maxReplicas }}
  minReplicas: {{ .Values.hpa.minReplicas }}
  scaleTargetRef: 
    apiVersion: apps/v1 
    kind: Deployment 
    name: {{ template "chart.fullname" . }} 
  metrics: 
{{- if .Values.hpa.metrics }}
{{- toYaml .Values.hpa.metrics | indent 4 }}
{{- else }}
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: {{ .Values.hpa.cpuUtil | default "80" }}
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: {{ .Values.hpa.memUtil | default "80" }}
{{- end }}
{{- end }}