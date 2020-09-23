# Tortobot controller

Un controller per [tortobot](http://greensystemtech.com/index.php/tortobot/), un robot basato sulla scheda Arduino e con un ricevitore bluetooth incorporato: la base perfetta per cominciare qualche esperimento con il bluetooth!

## Introduzione

Il progetto è stato iniziato con `flutter master`, utilizza un plugin che va ad interfacciarsi con i controller locali del bluetooth.

La dinamica di funzionamento è molto semplice: in seguito al collegamento via bluetooth a tortobot, l'app comincia ad inviare attraverso un monitor seriale i comandi che il robot interpreta e gestisce.