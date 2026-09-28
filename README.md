# Servidor de Redirecionamento HTTP

Um script simples em PowerShell que inicia um servidor HTTP local e redireciona as requisições recebidas para uma URL de destino especificada.

## Funcionalidades

- Inicia um servidor HTTP em uma porta personalizada.
- Aceita conexões em todas as interfaces de rede disponíveis.
- Redireciona requisições HTTP recebidas para uma URL especificada.
- Exibe informações sobre o servidor e as conexões no console.
- Identifica os endereços IP locais das interfaces Wi-Fi e Ethernet.

## Requisitos

- Windows
- PowerShell
- Acesso à rede na porta escolhida

## Como usar

Execute o script pelo PowerShell:

```powershell
.\redirect-server.ps1
