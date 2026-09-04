# Spese di casa

Web app statica su GitHub Pages, dati condivisi su Supabase. Due utenti,
Matteo e Gaia, ogni spesa con quote divisibili come si vuole. Solo CHF.

## Struttura

```
index.html                        l'app, file unico
schema.sql                        da eseguire una volta in Supabase
.github/workflows/heartbeat.yml   evita la pausa del progetto gratuito
```

## Installazione

1. **Supabase** — crea un progetto nuovo su supabase.com (piano gratuito,
   nessuna carta). Regione: Frankfurt o Zurigo, la più vicina.

2. **Schema** — apri SQL Editor, incolla tutto `schema.sql`, esegui.

3. **Utenti** — Authentication > Users > Add user, due volte: la tua email
   e quella di Gaia, con password. Lascia "Auto Confirm User" attivo.

4. **Collega gli utenti** — torna in SQL Editor, togli il commento dalle
   due `insert into public.membri` in fondo a `schema.sql`, metti le email
   vere ed esegui. Verifica con la `select` finale: devono uscire due righe.

5. **Chiudi le registrazioni** — Authentication > Sign In / Providers,
   disattiva "Allow new users to sign up". Senza questo chiunque abbia la
   anon key potrebbe crearsi un account (non vedrebbe le spese, perché non
   è in `membri`, ma tanto vale chiudere la porta).

6. **Chiavi** — Settings > API Keys. Copia il Project URL e la **publishable
   key** (`sb_publishable_...`) dentro `CONFIG` in cima allo script di
   `index.html`. Se il progetto mostra ancora solo le chiavi legacy con un
   pulsante per crearne di nuove, premilo e usa quelle nuove.

7. **Repo** — nuovo repo su GitHub, carica i tre file, poi Settings > Pages,
   sorgente branch `main`, cartella `/`.

8. **Heartbeat** — Settings > Secrets and variables > Actions, aggiungi
   `SUPABASE_URL` (lo stesso di prima) e `SUPABASE_SERVICE_KEY` (la **secret
   key**, `sb_secret_...`, non la publishable). Poi Actions > heartbeat
   supabase > Run workflow, per verificare che passi.

## Cose da sapere

- **La publishable key è pubblica.** Sta nel codice del sito, chiunque può
  leggerla. A proteggere i dati sono le policy RLS di `schema.sql`: solo un
  utente presente in `membri` legge o scrive le spese. Non toccare quelle
  policy.
- **La secret key non va mai in `index.html`.** Sta solo nei secrets di
  GitHub, perché scavalca la RLS.
- **Nomi delle chiavi.** I progetti creati da novembre 2025 non hanno più
  `anon` e `service_role`: publishable e secret sono gli equivalenti, con gli
  stessi permessi.
- **Sincronizzazione al reload.** Le spese dell'altra persona compaiono
  quando ricarichi o quando torni sull'app dopo averla lasciata. Non c'è
  push in tempo reale: si può aggiungere dopo attivando Realtime su Supabase.
- **Le Action programmate si fermano** se il repo resta senza commit per 60
  giorni. GitHub manda una mail prima di disattivarle.
- **Backup.** Il piano gratuito di Supabase non conserva backup. Usa il
  pulsante Esporta ogni tanto e tieni il JSON da parte.

## Prossimi passi possibili

- Modifica di una spesa già inserita (ora si può solo eliminare e rifare)
- Riepilogo per categoria e confronto tra mesi
- Spese ricorrenti inserite in automatico (affitto, abbonamenti)
- Tema scuro
- Realtime, se il reload diventa scomodo
