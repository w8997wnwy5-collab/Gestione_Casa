-- =====================================================================
-- Spese di casa — schema Supabase
-- Incollare tutto nell'SQL Editor di Supabase ed eseguire una volta sola.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Tabelle
-- ---------------------------------------------------------------------

-- Chi può usare l'app. Una riga per persona, collegata all'utente di login.
create table if not exists public.membri (
  user_id uuid primary key references auth.users (id) on delete cascade,
  nome    text not null unique check (nome in ('matteo', 'gaia'))
);

-- Le spese. Importi sempre in CHF.
-- quota_matteo = percentuale a carico di Matteo (0-100). Il resto è di Gaia.
-- tipo = 'spesa'    -> spesa di casa, divisa secondo le quote
-- tipo = 'rimborso' -> soldi passati da una persona all'altra per pareggiare
create table if not exists public.spese (
  id            uuid primary key default gen_random_uuid(),
  data          date not null default current_date,
  descrizione   text not null,
  categoria     text not null default 'Altro',
  importo       numeric(10,2) not null check (importo > 0),
  pagato_da     text not null check (pagato_da in ('matteo', 'gaia')),
  quota_matteo  numeric(5,2) not null default 50 check (quota_matteo between 0 and 100),
  tipo          text not null default 'spesa' check (tipo in ('spesa', 'rimborso')),
  note          text,
  creato_da     uuid references auth.users (id) default auth.uid(),
  creato_il     timestamptz not null default now()
);

create index if not exists spese_data_idx on public.spese (data desc, creato_il desc);

-- Tabella tecnica: la GitHub Action ci scrive ogni 3 giorni per evitare
-- che Supabase metta in pausa il progetto gratuito dopo 7 giorni fermi.
create table if not exists public.heartbeat (
  id     smallint primary key default 1 check (id = 1),
  ultimo timestamptz not null default now()
);
insert into public.heartbeat (id) values (1) on conflict (id) do nothing;

-- ---------------------------------------------------------------------
-- 2. Row Level Security
--    Senza queste regole i dati sarebbero leggibili da chiunque abbia
--    la anon key, che è pubblica dentro index.html.
-- ---------------------------------------------------------------------

alter table public.membri    enable row level security;
alter table public.spese     enable row level security;
alter table public.heartbeat enable row level security;
-- heartbeat resta senza policy: ci arriva solo la service_role key.

drop policy if exists "membri: leggo il mio profilo" on public.membri;
create policy "membri: leggo il mio profilo"
  on public.membri for select to authenticated
  using (user_id = auth.uid());

drop policy if exists "spese: accesso ai soli membri" on public.spese;
create policy "spese: accesso ai soli membri"
  on public.spese for all to authenticated
  using      (exists (select 1 from public.membri m where m.user_id = auth.uid()))
  with check (exists (select 1 from public.membri m where m.user_id = auth.uid()));

-- ---------------------------------------------------------------------
-- 3. Grants espliciti
--    Sui progetti creati dopo maggio 2026 la Data API non espone più le
--    tabelle senza grant esplicito, quindi vanno dati a mano.
-- ---------------------------------------------------------------------

grant usage on schema public to authenticated;
grant select on public.membri to authenticated;
grant select, insert, update, delete on public.spese to authenticated;

-- ---------------------------------------------------------------------
-- 4. Collegare i due account
--    Prima creare i due utenti in Authentication > Users, poi eseguire
--    queste due righe con le email vere.
-- ---------------------------------------------------------------------

-- insert into public.membri (user_id, nome)
-- select id, 'matteo' from auth.users where email = 'TUA_EMAIL_QUI';

-- insert into public.membri (user_id, nome)
-- select id, 'gaia' from auth.users where email = 'EMAIL_DI_GAIA_QUI';

-- Verifica finale: devono uscire due righe, matteo e gaia.
-- select nome, user_id from public.membri order by nome;
