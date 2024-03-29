{{- define "chart.vpa" -}}
apiVersion: autoscaling.k8s.io/v1
kind: VerticalPodAutoscaler 
metadata:
  name: {{ template "chart.fullname" . }}
  labels: {{- include "chart.labels" . | nindent 4 }}
spec: 
{{- $mode := "Off" | quote }}
{{- if .Values.vpa.updateMode }}
{{- $mode = .Values.vpa.updateMode | quote }}
{{- end }}
  updatePolicy:
    updateMode: {{ $mode }}
  targetRef: 
    apiVersion: apps/v1 
    kind: Deployment 
    name: {{ template "chart.fullname" . }} 
  resourcePolicy:
    containerPolicies:
    {{- with .Values.vpa }}
      - containerName: {{ .containers | default "*" }}
        minAllowed: {{- .minAllowed | toYaml | nindent 10 }}
        maxAllowed: {{- .maxAllowed | toYaml | nindent 10 }}
        controlledResources: ["cpu", "memory"]
    {{- end }}
{{- end }}
