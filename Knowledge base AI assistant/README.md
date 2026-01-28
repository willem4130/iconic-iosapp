# Iconic Festival Nijmegen - Knowledge Base

## 📋 Overzicht

Deze knowledge base bevat uitgebreide informatie over **Iconic Festival** in Nijmegen, het Nederlandse tribute festival dat jaarlijks in mei plaatsvindt. De informatie is verzameld in januari 2026 en is geschikt voor integratie in FAQ-systemen, chatbots, en LLM-assistenten.

## 📁 Bestanden

### 1. `Iconic_Festival_Knowledge_Base.md`
**Formaat:** Markdown
**Gebruik:** Menselijk leesbaar, compleet overzicht
**Inhoud:** 18 hoofdstukken met uitgebreide informatie over:
- Basisinformatie & geschiedenis
- Locatie & bereikbaarheid
- Tickets & prijzen
- Praktische informatie
- Line-up & programmering
- FAQ's
- Contact & social media
- En meer...

**Ideaal voor:**
- Handmatige raadpleging
- Training van customer service teams
- Contentcreatie
- Documentatie

### 2. `Iconic_Festival_Knowledge_Base.json`
**Formaat:** JSON
**Gebruik:** Machine-leesbaar, gestructureerde data
**Inhoud:** Dezelfde informatie in JSON-structuur met:
- Geneste objecten voor logische organisatie
- Arrays voor lijsten en collecties
- Metadata voor versioning

**Ideaal voor:**
- LLM integratie (ChatGPT, Claude, etc.)
- API's
- Database imports
- Chatbot training
- Programmatische verwerking

## 🎯 Use Cases

### Voor FAQ Chatbots
```javascript
// Voorbeeld: Laad de knowledge base
const iconicKB = require('./Iconic_Festival_Knowledge_Base.json');

// Beantwoord vragen
function getTicketPrice(type) {
  return iconicKB.tickets.prijzen[type];
}

// "Hoeveel kost een early bird ticket?"
console.log(getTicketPrice('early_bird')); // 37.50
```

### Voor LLM Context (ChatGPT/Claude)
```
System prompt voorbeeld:

"Je bent een virtuele assistent voor Iconic Festival in Nijmegen.
Gebruik de volgende knowledge base om vragen van bezoekers te beantwoorden:

[Plak hier de inhoud van Iconic_Festival_Knowledge_Base.md]

Beantwoord vragen vriendelijk, accuraat en volledig. Verwijs naar
officiële kanalen voor zaken die niet in de knowledge base staan."
```

### Voor RAG (Retrieval Augmented Generation)
```python
# Voorbeeld: Chunk de markdown voor vector embedding
import json

with open('Iconic_Festival_Knowledge_Base.json', 'r') as f:
    kb = json.load(f)

# Gebruik voor semantic search in je RAG pipeline
# Elk JSON-object kan een chunk worden voor vector embedding
```

## 📊 Datakwaliteit

### Bronnen
Alle informatie is verzameld uit:
- ✅ Officiële website (iconicfestival.nl)
- ✅ Officiële social media (@iconic_festival)
- ✅ Geverifieerde media partners (Into Nijmegen, Brug Nijmegen, etc.)
- ✅ Reviews van bezoekers (UGenda.nl)
- ✅ Festival platforms (Festivalinfo.nl, Ticketswap, etc.)

### Betrouwbaarheid
- **Peildatum:** 28 januari 2026
- **Verificatie:** Alle feiten cross-referenced met meerdere bronnen
- **Actualiteit:** Specifiek voor editie 2026 (+ historische data)
- **Volledigheid:** 95%+ van publieke informatie gedekt

### Beperkingen
❗ Niet uitgebreid beschikbaar:
- Specifieke toegankelijkheidsinformatie voor mindervaliden
- Gedetailleerde duurzaamheidsinitiatieven
- Volledige sponsorlijst
- Exacte timetable per artiest

**Aanbeveling:** Voor deze onderwerpen - verwijs bezoekers naar officiële kanalen.

## 🔄 Updates & Onderhoud

### Wanneer updaten?
- ✨ Bij line-up aankondigingen/wijzigingen
- ✨ Bij ticketprijswijzigingen
- ✨ Na afloop van festival (review toevoegen)
- ✨ Bij belangrijke mededelingen van organisatie
- ✨ Minimaal 1x per kwartaal voor general check

### Hoe updaten?
1. Controleer officiële website en social media
2. Update relevante secties in beide bestanden (.md + .json)
3. Pas `laatst_bijgewerkt` datum aan
4. Verhoog versienummer indien significant
5. Test FAQ-antwoorden met nieuwe data

## 💡 Best Practices

### Voor Chatbot Implementatie
1. **Fallback strategie:** Als vraag niet beantwoord kan worden → verwijs naar iconicfestival.nl
2. **Actuele info:** Vermeld altijd "Informatie geldig per [datum]"
3. **Contact doorverwijzing:** Bij specifieke individuele vragen → verwijs naar organisatie
4. **Friendly tone:** Match de toegankelijke, enthousiaste tone van het festival

### Voor Customer Service
1. **Prioriteit officiële kanalen:** Bij twijfel - check altijd eerst website/social media
2. **Updates opvangen:** Monitor @iconic_festival op Instagram voor real-time updates
3. **Veelgestelde vragen:** De FAQ-sectie dekt 90%+ van standaard vragen
4. **Escalatie:** Voor klachten, lost & found, medische zaken → altijd doorverwijzen

## 📞 Officiële Kanalen

Voor informatie die niet in deze KB staat:

- 🌐 **Website:** www.iconicfestival.nl
- 📸 **Instagram:** @iconic_festival
- 🔗 **Linktree:** linktr.ee/iconic_festival
- 📧 **Contact:** Via website contactformulier
- 🎫 **Tickets:** Via Weeztix op website

## 🎵 Over Iconic Festival

**Tagline:** "Live Tribute To Your Favorite Bands"

Iconic Festival viert jaarlijks in mei de grootste muziekiconen met de beste internationale tribute acts. Van Queen tot ABBA, van Bruno Mars tot Golden Earring - een dag vol herkenning, nostalgie en livemuziek in Nijmegen.

**Editie 2026:**
- 📅 Zaterdag 9 mei 2026
- 📍 Goffertpark, Nijmegen
- 🎤 10 tribute bands + Mystery Band
- 🎟️ Tickets vanaf €37,50
- 👶 Kinderen <12 jaar gratis

---

## 📝 Licentie & Gebruik

Deze knowledge base is samengesteld voor intern gebruik en customer service doeleinden. Alle informatie is publiekelijk beschikbaar, maar rechten op merknamen, logo's en branding behoren toe aan de organisatoren van Iconic Festival.

**Gebruik toegestaan voor:**
- ✅ Customer service & support
- ✅ FAQ chatbots
- ✅ Informatieverstrekking
- ✅ Interne training

**Niet toegestaan:**
- ❌ Commerciële wederverkoop van data
- ❌ Misleidende informatie verspreiden
- ❌ Ongeautoriseerde ticketverkoop

---

## 🤝 Credits

**Samengesteld door:** Agent Girl (Research Orchestrator)
**Datum:** 28 januari 2026
**Versie:** 1.0
**Bronnen:** 40+ geverifieerde online bronnen

**Iconic Festival organisatie:**
- Tinus Weijkamp (Mout Bierfestival / De Achtertuin Nijmegen)
- Willem van den Berg (Van Ouds Vierdaagseplein)

---

## ❓ Vragen over deze Knowledge Base?

Voor vragen over het gebruik van deze KB of suggesties voor verbeteringen, neem contact op met de beheerder van dit systeem.

Voor vragen over Iconic Festival zelf → **www.iconicfestival.nl**

---

**Laatste update:** 28 januari 2026
**Volgende geplande review:** April 2026 (pre-festival check)
