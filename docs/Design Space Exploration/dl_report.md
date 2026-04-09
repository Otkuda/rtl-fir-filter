# Исследование имплементаций блоков памяти

## Цель исследования

Оценка аппаратных затрат, максимальной тактовой частоты и энергопотребления при различных реализациях блоков памяти. Модуля для хранения коэффициентов фильтра и модуля линии задержки

Все метрики собирались с оптимизированным под DSP блок вычислительным ядром.

### Распределенная память без выходного регистра


<details>
  <summary> <b>Schematic</b> </summary>

</details>

<details>
  <summary> <b>Utilization Report</b> </summary>

  ```
+----------+------+---------------------+
| Ref Name | Used | Functional Category |
+----------+------+---------------------+
| FDRE     | 6221 |        Flop & Latch |
| LUT6     | 1662 |                 LUT |
| MUXF7    |  816 |               MuxFx |
| MUXF8    |  384 |               MuxFx |
| RAMD64E  |  176 |  Distributed Memory |
| LUT2     |  173 |                 LUT |
| LUT5     |  148 |                 LUT |
| LUT3     |  122 |                 LUT |
| LUT4     |   33 |                 LUT |
| FDCE     |   30 |        Flop & Latch |
| CARRY4   |   14 |          CarryLogic |
| LUT1     |    7 |                 LUT |
| FDPE     |    2 |        Flop & Latch |
| DSP48E1  |    2 |    Block Arithmetic |
+----------+------+---------------------+
  ```

</details>


<details>
  <summary> <b>Timing Report</b> </summary>

```
------------------------------------------------------------------------------------------------
| Design Timing Summary
| ---------------------
------------------------------------------------------------------------------------------------

    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints     WPWS(ns)     TPWS(ns)  TPWS Failing Endpoints  TPWS Total Endpoints  
    -------      -------  ---------------------  -------------------      -------      -------  ---------------------  -------------------     --------     --------  ----------------------  --------------------  
     -5.324   -12622.654                   5570                 9865        0.109        0.000                      0                 9865       -0.545      -45.090                     178                  6495  

```

$$F_{max} = \frac{1}{(2 - (-5.324)) * 10^{-9}} = 136537411.251 Hz \approx 137 MHz$$

### Блочная память с одним выходным регистром


<details>
  <summary> <b>Schematic</b> </summary>

</details>

<details>
  <summary> <b>Utilization Report</b> </summary>

  ```
  +----------+------+---------------------+
  | Ref Name | Used | Functional Category |
  +----------+------+---------------------+
  | RAMD64E  |  176 |  Distributed Memory |
  | LUT2     |  176 |                 LUT |
  | LUT3     |  125 |                 LUT |
  | FDRE     |   84 |        Flop & Latch |
  | LUT6     |   53 |                 LUT |
  | FDCE     |   30 |        Flop & Latch |
  | LUT4     |   28 |                 LUT |
  | CARRY4   |   16 |          CarryLogic |
  | LUT5     |   15 |                 LUT |
  | LUT1     |    9 |                 LUT |
  | RAMB18E1 |    2 |        Block Memory |
  | FDPE     |    2 |        Flop & Latch |
  | DSP48E1  |    2 |    Block Arithmetic |
  +----------+------+---------------------+
  ```

</details>


<details>
  <summary> <b>Timing Report</b> </summary>

```
------------------------------------------------------------------------------------------------
| Design Timing Summary
| ---------------------
------------------------------------------------------------------------------------------------

    WNS(ns)      TNS(ns)  TNS Failing Endpoints  TNS Total Endpoints      WHS(ns)      THS(ns)  THS Failing Endpoints  THS Total Endpoints     WPWS(ns)     TPWS(ns)  TPWS Failing Endpoints  TPWS Total Endpoints  
    -------      -------  ---------------------  -------------------      -------      -------  ---------------------  -------------------     --------     --------  ----------------------  --------------------  
     -3.829    -1255.935                   1093                 1688        0.097        0.000                      0                 1688       -0.944      -48.498                     182                   298  

```

$$F_{max} = \frac{1}{(2 - (-3.829)) * 10^{-9}} = 171556013.0382 Hz \approx 172 MHz$$