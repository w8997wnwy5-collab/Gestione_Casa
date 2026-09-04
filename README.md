# Spese di casa

Web app statica su GitHub Pages, dati condivisi su Supabase. Due utenti,
Matteo e Gaia, ogni spesa con quote divisibili come si vuole. Solo CHF.

## File

```
index.html                        l'app, file unico
manifest.webmanifest              serve per installarla in home
icon-192.png icon-512.png         icone dell'app
apple-touch-icon.png favicon.png  icone per iPhone e per la scheda del browser
schema.sql                        già eseguito, si tiene come riferimento
.github/workflows/heartbeat.yml   evita la pausa del progetto gratuito
```

## Aggiornare all'ultima versione

Carica nel repo `index.html` (sostituendo quello vecchio), `manifest.webmanifest`
e i quattro png, tutti nella cartella principale. Il database non si tocca:
lo schema è lo stesso, nessuna query da rieseguire.

Dopo il commit, GitHub Pages ci mette circa un minuto. Se vedi ancora la
versione vecchia, ricarica tenendo premuto il tasto di refresh, oppure apri
la pagina in una scheda anonima: è la cache del browser.

## Metterla in home sul telefono

- **iPhone**: apri il sito in Safari, tasto Condividi, "Aggiungi alla schermata
  Home". Deve essere Safari, da Chrome iOS non funziona.
- **Android**: apri in Chrome, menu con i tre puntini, "Installa app" o
  "Aggiungi a schermata Home".

Da lì si apre a tutto schermo, senza barra del browser, con la sua icona.

## Cosa c'è dentro

- **Spese** — saldo in evidenza, elenco del mese con icona e colore per
  categoria, quanto ti è costata ogni voce, filtro per categoria. Tocca una
  riga per modificarla o eliminarla.
- **Riepilogo** — totale del mese e confronto col mese prima, anello per
  categoria con percentuali, quanto ha anticipato ciascuno e quanto è a
  carico di ciascuno, andamento degli ultimi sei mesi.
- **Pareggia** — inserisce il rimborso che riporta il saldo a zero, con
  l'importo già compilato.
- Tema chiaro e scuro in automatico, secondo le impostazioni del telefono.

## Cose da sapere

- **La publishable key è pubblica.** Sta nel codice del sito, chiunque può
  leggerla. A proteggere i dati sono le policy RLS di `schema.sql`: solo un
  utente presente in `membri` legge o scrive le spese. Non toccare quelle
  policy.
- **La secret key non va mai in `index.html`.** Sta solo nei secrets di
  GitHub, perché scavalca la RLS.
- **Sincronizzazione al reload.** Le spese dell'altra persona compaiono
  quando ricarichi o quando torni sull'app dopo averla lasciata.
- **Le Action programmate si fermano** se il repo resta senza commit per 60
  giorni. GitHub avvisa per mail prima di disattivarle.
- **Backup.** Il piano gratuito di Supabase non conserva backup. Usa Esporta
  ogni tanto e tieni il JSON da parte.

## Prossimi passi possibili

- Spese ricorrenti inserite in automatico (affitto, abbonamenti)
- Categorie personalizzate invece di quelle fisse
- Budget mensile per categoria con avviso al superamento
- Funzionamento offline con service worker
- Realtime, se il reload diventa scomodo
