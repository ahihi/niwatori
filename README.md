# Niwatori

Annotates [kana](https://en.wikipedia.org/wiki/Kana) symbols with their romanizations.

    $ stack exec -- niwatori-exe "にわとり"
    にわとり niwatori (にni わwa とto りri)
    $ stack exec -- niwatori-exe --json "にわとり"
    [{"romaji":"niwatori","kana":"にわとり","characters":[{"romaji":"ni","kana":"に"},{"romaji":"wa","kana":"わ"},{"romaji":"to","kana":"と"},{"romaji":"ri","kana":"り"}]}]
