{{- define "chart.ingress.tpl.path" -}}
{{- $ := .root }}
{{- $path := .pathConfig }}
- path: {{ if eq $path.path "root" }}{{ printf "/" }}{{ else }}{{ printf "/%s" $path.path }}{{ end }}
  pathType: {{ default "ImplementationSpecific" $path.pathType }}
  backend:
    service:
      name: {{ default (include "chart.fullname" $) $path.service }}
      port:
      {{- if not (hasKey $path "portName") }}
        {{- if hasKey $path "port" }}
        number: {{ $path.port }}
        {{- else if $.Values.service }}
        number: {{ (index $.Values.service.ports 0).port }}
        {{- else }}
        name: "main"
        {{- end }}
      {{- else }}
        name: {{ default "main" $path.portName }}
      {{- end }}
{{- end }}

{{- define "chart.ingress.multi" }}
apiVersion: {{ include "common.capabilities.ingress.apiVersion" . }}
kind: Ingress
metadata:
  name: {{ template "chart.fullname" . }}
  labels: {{ include "chart.labels" . | nindent 4 }}
  {{- if hasKey .Values.ingress "annotations" }}
  annotations: {{ toYaml .Values.ingress.annotations | nindent 4 }}
  {{- end }}
spec:
  ingressClassName: {{ default "nginx" .Values.ingress.className }}
  {{- if and (hasKey .Values.ingress "tls") .Values.ingress.tls.enabled | default ("true") }}
  tls:
    - hosts:
      {{- range $domain, $val := .Values.ingress.config }}
      {{- printf "- %s" ($domain | toString | quote) | nindent 8 }}
      {{- end }}
      {{- if and (hasKey .Values.ingress "tls") (hasKey .Values.ingress.tls "secretName") }}
      secretName: {{ .Values.ingress.tls.secretName }}
      {{- else }}
      secretName: {{ .Release.Name }}-tls
      {{- end }}
  {{- end }}  
  rules:
  {{- range $domain, $val := .Values.ingress.config }}
    - host: {{ $domain }}
      http:
        paths:
        {{- if hasKey . "paths" }}
        {{- range $path := .paths }}
        {{- include "chart.ingress.tpl.path" (dict "root" $ "pathConfig" .) | indent 10 }}
        {{- end }}
        {{- else }}
        {{- include "chart.ingress.tpl.path" (dict "root" $ "pathConfig" .) | indent 10 }}
        {{- end }}
  {{- end }}
{{- end }}
