{{- define "chart.job.multi" -}}
{{- range $job, $val := .Values.jobs }}
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ $job }}
  labels:
{{ include "chart.labels" $ | indent 4 }}
{{- with .annotations }}
  annotations:
{{- toYaml . | nindent 4 }}
{{- end }}
spec:
  concurrencyPolicy: {{ .concurrencyPolicy }}
  ttlSecondsAfterFinished: {{ .ttlSecondsAfterFinished }}
  template:
    metadata:
      name: {{ $job }}
    spec:
{{- if $.Values.global.imagePullSecret }}
      imagePullSecrets:
        - name: {{ $.Values.global.imagePullSecret }}
{{- else }}
{{- with .image }}
      imagePullSecrets:
        - name: {{ .pullPolicy }}
{{- end }}
{{- end }}
        containers:
        - name: {{ $job }}
{{- with .image }}
        image: "{{ tpl .repository $ }}/{{ tpl .name $ }}:{{ tpl .tag $ }}"
        imagePullPolicy: "{{ tpl .pullPolicy $ }}"
{{- end }}
{{- with .command }}
        command: 
{{ toYaml . | nindent 14  }}
{{- end }}
{{- with .args }}
        args: 
{{ toYaml . | nindent 14  }}
{{- end }}
        env:
{{- with .extraEnv }}
{{ toYaml . | nindent 14 }}
{{- end }}
{{- range $key, $value := .envVars }}
{{- printf "- name: %s\n  value: %s" $key ($value | toString | quote) | nindent 14 }}
{{- end }}
{{- with .envFrom }}
        envFrom:
{{- toYaml . | nindent 14 }}
{{- end }}
{{- with .envFromTpl }}
        envFrom:
{{- tpl . $ | nindent 14 }}
{{- end }}
{{- with .volumeMounts }}
        volumeMounts:
{{- toYaml . | nindent 14 }}
{{- end }}
      volumes:
{{- with .volumes }}
{{- toYaml . | nindent 12 }}
{{- end }}
{{- with .volumestpl }}
{{- tpl . $ | nindent 12 }}
{{- end }}
      restartPolicy: {{ .restartPolicy }}
{{- with .nodeSelector }}
      nodeSelector:
{{- toYaml . | nindent 12 }}
{{- end }}
---
{{- end }}
{{- end }}