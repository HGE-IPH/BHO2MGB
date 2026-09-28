# BHO2MGB

<p align="left">
  <img src="bho2mgb_plugin/icon.png" alt="BHO2MGB logo" width="180">
</p>

English and Portuguese descriptions below

**Application manual (English):** [Markdown](docs/en/index.md) · [PDF](docs/en/manual-bho2mgb.pdf) · [build instructions](docs/en/README.md)

**Manual de aplicação (português):** [Markdown](docs/pt/index.md) · [PDF](docs/pt/manual-bho2mgb.pdf) · [como gerar o PDF](docs/pt/README.md)

---
#### [en]


BHO2MGB is a QGIS plugin for preparing input data for the [MGB Large Basin Model](https://www.ufrgs.br/hge/mgb/downloads/mgb-4-6-2/) using Brazil's [Ottocoded Hydrographic Base (BHO)](https://www.gov.br/ana/). It discretizes MGB using the BHO river reaches and catchment polygons. Since the BHO already contains most of the information needed to build MGB's main input file (`MINI.gtp`), this workflow does not require the digital elevation model preprocessing used by other approaches, such as [IPH Hydro Tools](https://www.ufrgs.br/hge/modelos-e-outros-produtos/iph-hydro-tools/).

Using the official ANA hydrographic network makes it easier to transfer MGB results to that network and produce information useful for water resources management.

### BHO2MGB Toolkit

The BHO data preprocessing step is available as an application in [Google Earth Engine](https://bho2mgb.users.earthengine.app/view/mgbbhotoolkit).

### Tutorials

Select a thumbnail to watch the video on YouTube.

[![BHO2MGB Part 1: Toolkit](https://img.youtube.com/vi/Moi7PyDXlGM/hqdefault.jpg)](https://www.youtube.com/watch?v=Moi7PyDXlGM)

[![BHO2MGB Part 2: QGIS Plugin](https://img.youtube.com/vi/wUWT_MO4eFk/hqdefault.jpg)](https://www.youtube.com/watch?v=wUWT_MO4eFk)

### Authors

| Initials | Author | Role |
|---|---|---|
| RB | Rafael Barbedo | Lead and core development |
| GM | Gabriel Matte | Toolkit for downloading input data |
| LL | Leonardo Laipelt | QGIS integration and UI |
| RO | Rafaela Oliveira | Support, testing, and documentation |
| WC | Walter Collischonn | Coordination |

---
#### [pt]

O BHO2MGB é um plugin para QGIS que realiza o pré-processamento de dados para o [Modelo de Grandes Bacias (MGB)](https://www.ufrgs.br/hge/mgb/downloads/mgb-4-6-2/) utilizando informações da [Base Hidrográfica Ottocodificada (BHO)](https://www.gov.br/ana/). O plugin discretiza o MGB com base nos trechos de rio e polígonos da BHO. Como a BHO já contém quase todas as informações necessárias para compor o principal arquivo de entrada do MGB (`MINI.gtp`), esse fluxo dispensa o pré-processamento do modelo digital de elevação utilizado em outras abordagens, como o [IPH Hydro Tools](https://www.ufrgs.br/hge/modelos-e-outros-produtos/iph-hydro-tools/).

O uso da rede hidrográfica oficial da ANA facilita a transferência dos resultados do MGB para essa rede e a obtenção de informações relevantes para a gestão de recursos hídricos.

### BHO2MGB Toolkit

O pré-processamento dos arquivos da BHO está disponível em um aplicativo no [Google Earth Engine](https://bho2mgb.users.earthengine.app/view/mgbbhotoolkit).

### Vídeos tutoriais

Clique em uma miniatura para assistir ao vídeo no YouTube.

[![BHO2MGB Parte 1: ToolKit](https://img.youtube.com/vi/Moi7PyDXlGM/hqdefault.jpg)](https://www.youtube.com/watch?v=Moi7PyDXlGM)

[![BHO2MGB Parte 2: Plugin QGIS](https://img.youtube.com/vi/wUWT_MO4eFk/hqdefault.jpg)](https://www.youtube.com/watch?v=wUWT_MO4eFk)

### Autores

| Sigla | Autor | Função |
|---|---|---|
| RB | Rafael Barbedo | Liderança e desenvolvimento principal |
| GM | Gabriel Matte | Toolkit para baixar os dados de entrada |
| LL | Leonardo Laipelt | Integração com o QGIS e interface |
| RO | Rafaela Oliveira | Suporte, testes e documentação |
| WC | Walter Collischonn | Coordenação |
