{{- define "chart.hpa" -}}
{{- $hpa := .Values.hpa | default (dict "maxReplicas" 1 "minReplicas" 1 "cpuUtil" 80 "memUtil" 80) }}
{{- if .Capabilities.APIVersions.Has "autoscaling/v2" }}
apiVersion: autoscaling/v2
{{- else }}
apiVersion: autoscaling/v2beta2
{{- end }}
kind: HorizontalPodAutoscaler
metadata:
  name: {{ template "chart.fullname" . }}
  labels: {{ include "chart.labels" . | nindent 4 }}
spec:
  maxReplicas: {{ default 1 $hpa.maxReplicas }}
  minReplicas: {{ default 1 $hpa.minReplicas }}
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ template "chart.fullname" . }}
  metrics:
  {{- if $hpa.metrics }}
  {{ toYaml $hpa.metrics | nindent 4 }}
  {{- else }}
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: {{ default 80 $hpa.cpuUtil }}
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: {{ default 80 $hpa.memUtil }}
  {{- end }}
{{- end }}
