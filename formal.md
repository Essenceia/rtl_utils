# Collection of formal tricks

#### Is thermometer 

Check if `logic [W-1:0] data` is a thermometer.

```
sva_thermo : assert ( $onehot( data + W'd1 ));
```


