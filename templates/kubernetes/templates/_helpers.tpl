{{- define "{{ .Chart.Name }}.fullname" -}}
{{- if contains .Chart.Name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "{{ .Chart.Name }}.commonLabels" -}}
app.kubernetes.io/name: "{{ .Release.Name }}"
helm.sh/chart: "{{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}"
app.kubernetes.io/managed-by: "{{ $.Release.Service }}"
app.kubernetes.io/version: "{{ $.Chart.Version }}"
app.kubernetes.io/component: "{{ $.Chart.Name }}"
app.kubernetes.io/part-of: "{{ $.Chart.Name }}"
{{- end -}}

{{- define "{{ .Chart.Name }}.appLabel" -}}
app.kubernetes.io/name: "{{ include "{{ .Chart.Name }}.fullname" . }}"
{{- end -}}
