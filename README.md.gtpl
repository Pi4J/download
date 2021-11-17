{{- define "file-size" -}}
{{- if gt . 1073741824 -}}
{{- printf "%.2f GiB" (math.Div . 1073741824) -}}
{{- else if gt . 1048576 -}}
{{- printf "%.2f MiB" (math.Div . 1048576) -}}
{{- else if gt . 1024 -}}
{{- printf "%.2f KiB" (math.Div . 1024) -}}
{{- else -}}
{{- printf "%d B" . }}
{{- end -}}
{{- end -}}

{{- define "pi4j-download-single" -}}
{{- $baseURL := "https://github.com/Pi4J/download/raw/main/" }}
{{- $fileURL := printf "%s%s" $baseURL .name -}}
[{{ .name }} ({{ template "file-size" .size }} | {{ .date }})]({{ $fileURL }})
{{- end -}}

{{- define "pi4j-download-list" -}}
{{- $baseURL := "https://github.com/Pi4J/download/raw/main/" }}
{{- range $index, $file := . }}
{{- $fileURL := printf "%s%s" $baseURL $file.name }}
<tr>
    <td nowrap>{{ $file.name }}</td>
    <td nowrap>{{ template "file-size" $file.size }}</td>
    <td><a href="{{ $fileURL }}">{{ $fileURL }}</a></td>
    <td nowrap>{{ $file.date }}</td>
</tr>
{{- end }}
{{- end -}}

{{- define "pi4j-os-single" -}}
{{- $baseURL := "https://pi4j-download.com/" }}
{{- $fileURL := printf "%s%s" $baseURL .name -}}
[{{ .name }} ({{ template "file-size" .size }} | {{ .date }})]({{ $fileURL }})
{{- end -}}

{{- define "pi4j-os-list" -}}
{{- $baseURL := "https://pi4j-download.com/" }}
{{- range $index, $file := . }}
{{- $fileURL := printf "%s%s" $baseURL $file.name }}
<tr>
    <td>{{ $file.name }}</td>
    <td>{{ template "file-size" $file.size }}</td>
    <td><a href="{{ $fileURL }}">{{ $fileURL }}</a></td>
    <td>{{ $file.date }}</td>
</tr>
<tr>
    <td colspan="4"><i>Image SHA256: <code>{{ $file.checksum }}</code></i></td>
</tr>
{{- end }}
{{- end -}}

# Pi4J Download Repository

![CI Status: pi4j-rebuild-repo](https://github.com/Pi4J/download/workflows/pi4j-rebuild-repo/badge.svg)
![CI Status: pi4j-dynamic-readme](https://github.com/Pi4J/download/workflows/pi4j-dynamic-readme/badge.svg)

This repository host the **Pi4J APT/PPA Package Repository** accessible via [pi4j.com/download](https://pi4j.com/download).

The download files are located on [github.com/Pi4J/download](https://github.com/Pi4J/download).

For more information about the Pi4J Project, please see: [pi4j.com](https://pi4j.com/).

## Latest Downloads
- **Latest Release:** {{ template "pi4j-download-single" (index .pi4j_download.release_archives 0) }}
- **Latest Snapshot:** {{ template "pi4j-download-single" (index .pi4j_download.snapshot_archives 0) }}
- **Latest CrowPi OS Image:** {{ template "pi4j-os-single" (index .pi4j_os.flavors.crowpi 0) }}
- **Latest Picade OS Image:** {{ template "pi4j-os-single" (index .pi4j_os.flavors.picade 0) }}

## All Downloads
- **[Release Archives](#release-archives)**: stable Pi4J builds for use in your own projects
- **[Snapshot Archives](#snapshot-archives)**: experimental Pi4J builds, might cause breakage
- **[APT/PPA Repository](#aptppa-repository)**: install Pi4J via APT/PPA system package manager
- **[Operating System Images](#operating-system-images)**: install custom OS images based on Raspbian to kickstart your Pi4J project

---

## Release Archives
<table>
<thead>
    <tr>
        <th>Name</th>
        <th>Size</th>
        <th>Download URL</th>
        <th>Date</th>
    </tr>
</thead>
<tbody>
    {{- template "pi4j-download-list" .pi4j_download.release_archives }}
</tbody>
</table>

---

## Snapshot Archives
<table>
<thead>
    <tr>
        <th>Name</th>
        <th>Size</th>
        <th>Download URL</th>
        <th>Date</th>
    </tr>
</thead>
<tbody>
    {{- template "pi4j-download-list" .pi4j_download.snapshot_archives }}
</tbody>
</table>

---

## APT/PPA Repository
### Automated Installation
The easiest way to get started with the Pi4J APT/PPA repository is to use our pre-built installation scripts:

- **Pi4J Version 2:** `curl -sSL https://pi4j.com/v2/install | sudo bash`
- **Pi4J Version 1:** `curl -sSL https://pi4j.com/install | sudo bash`

### Manual Installation
Should you decide against running our installer script, you can also use these commands to setup the appropriate repository:

<details>
<summary><b>Pi4J Version 2 (stable)</b></summary>

<pre><code>wget -qO- https://pi4j.com/pi4j.gpg | sudo apt-key add -
echo 'deb [arch=all] https://pi4j.com/download v2 stable' | sudo tee /etc/apt/sources.list.d/pi4j.list
sudo apt update
sudo apt install pi4j</code></pre>

</details>

<details>
<summary><b>Pi4J Version 2 (testing)</b></summary>

<pre><code>wget -qO- https://pi4j.com/pi4j.gpg | sudo apt-key add -
echo 'deb [arch=all] https://pi4j.com/download v2 testing' | sudo tee /etc/apt/sources.list.d/pi4j.list
sudo apt update
sudo apt install pi4j</code></pre>

</details>

<details>
<summary><b>Pi4J Version 1 (stable)</b></summary>

<pre><code>wget -qO- https://pi4j.com/pi4j.gpg | sudo apt-key add -
echo 'deb [arch=all] https://pi4j.com/download v1 stable' | sudo tee /etc/apt/sources.list.d/pi4j.list
sudo apt update
sudo apt install pi4j</code></pre>

</details>

<details>
<summary><b>Pi4J Version 1 (testing)</b></summary>

<pre><code>wget -qO- https://pi4j.com/pi4j.gpg | sudo apt-key add -
echo 'deb [arch=all] https://pi4j.com/download v1 testing' | sudo tee /etc/apt/sources.list.d/pi4j.list
sudo apt update
sudo apt install pi4j</code></pre>

</details>

---

## Operating System Images
Use these pre-built operating system images of the Pi4J project to kickstart your own 100% pure Java applications for specific Raspberry Pi setups.
Please note that the given SHA256 checksums refer to the image file contained within the ZIP archive and not the ZIP archive itself.
Visit the official [GitHub Repository](https://github.com/Pi4J/pi4j-os) to learn more.

### CrowPi
<table>
<thead>
    <tr>
        <th>Name</th>
        <th>Size</th>
        <th>Download URL</th>
        <th>Date</th>
    </tr>
</thead>
<tbody>
    {{- template "pi4j-os-list" .pi4j_os.flavors.crowpi }}
</tbody>
</table>

### Picade
<table>
<thead>
    <tr>
        <th>Name</th>
        <th>Size</th>
        <th>Download URL</th>
        <th>Date</th>
    </tr>
</thead>
<tbody>
    {{- template "pi4j-os-list" .pi4j_os.flavors.picade }}
</tbody>
</table>

Thanks to our sponsor [Karakun](https://karakun.com/) for hosting these images!
