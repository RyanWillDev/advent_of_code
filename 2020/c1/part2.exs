x = [
  1082,
  1770,
  1104,
  1180,
  1939,
  1952,
  1330,
  1569,
  1120,
  1281,
  1144,
  1091,
  2008,
  1967,
  1863,
  1819,
  1813,
  1986,
  1099,
  1860,
  1686,
  1063,
  1620,
  1107,
  1095,
  951,
  1897,
  1246,
  1264,
  1562,
  1151,
  1980,
  1942,
  1416,
  1170,
  1258,
  1075,
  1882,
  1329,
  2003,
  66,
  1249,
  1302,
  1221,
  1828,
  1154,
  1662,
  1103,
  1879,
  1205,
  1936,
  1472,
  1816,
  1071,
  1237,
  1467,
  1919,
  942,
  74,
  1178,
  1949,
  1947,
  1613,
  1931,
  1332,
  24,
  1987,
  1796,
  1256,
  1981,
  1158,
  1114,
  2004,
  1696,
  1775,
  1718,
  1102,
  1998,
  1540,
  1129,
  1870,
  1841,
  1582,
  1173,
  1417,
  1604,
  1214,
  1941,
  1440,
  1381,
  1149,
  1111,
  1766,
  1747,
  1940,
  960,
  1449,
  1171,
  1584,
  1926,
  1065,
  1832,
  1633,
  1245,
  1889,
  1906,
  1198,
  1959,
  1340,
  1951,
  1347,
  1097,
  1660,
  1957,
  1134,
  1730,
  1105,
  1124,
  1073,
  1679,
  1397,
  1963,
  1136,
  1983,
  1806,
  1964,
  1821,
  1997,
  1254,
  1823,
  1092,
  1119,
  2000,
  1089,
  1933,
  1478,
  1923,
  1576,
  1571,
  415,
  1875,
  1937,
  1112,
  1831,
  1969,
  1506,
  1929,
  1960,
  1322,
  110,
  1141,
  1080,
  1603,
  1126,
  1036,
  1762,
  1904,
  1122,
  1988,
  1962,
  1958,
  1953,
  1068,
  1188,
  1483,
  1518,
  1471,
  1961,
  1217,
  1559,
  1789,
  1523,
  2007,
  1093,
  1745,
  1955,
  1948,
  1474,
  1628,
  691,
  1398,
  1876,
  1650,
  1838,
  1950,
  1088,
  1697,
  1977,
  1364,
  1966,
  1945,
  1975,
  1606,
  1974,
  1847,
  1570,
  1148,
  1599,
  1772,
  1970
]

t = [
  675,
  1721,
  979,
  366,
  299,
  1456
]

r =
  Enum.reduce_while(t, {nil, 0, nil, [], %{}}, fn
    # First clause just delays so we can check first 2 numbers
    n, {_, i, nil, prev, m} ->
      {:cont, {nil, i + 1, n, prev, m}}

    n, {_, i, last, prev, m} ->
      # Check if current value is one we need
      pair = Map.get(m, n)

      # This will stop the search if the current value meets the conditions
      if pair do
        IO.inspect(m, label: "current check")
        {x, y} = pair
        {:halt, {{x, y, n}, i}}
      else
        # Add the current and last numbers and subtract from sum to see what
        # number we need to meet the sum
        need = 2020 - (n + last)

        m =
          if need <= 0 do
            # Since the number we'd need is either 0 or a negative, neither of
            # which are contained in the list, we don't need to add it to the
            # map
            m
          else
            Map.update(m, need, {n, last}, fn _ -> raise "already exists" end)
          end

        r =
          Enum.reduce_while(prev, {false, nil}, fn p, {_, _} = acc ->
            # Since the map of numbers we are looking for may have changed we
            # need to check if any of the previously seen numbers are now
            # a match
            pair = Map.get(m, p)

            if pair do
              IO.inspect(p, label: "prev check")
              {x, y} = pair
              {:halt, {true, {x, y, p}}}
            else
              {:cont, acc}
            end
          end)

        case r do
          # This will stop the search if the value we were looking for was
          # previously seen
          {true, nums} ->
            {:halt, {nums, i}}

          {_, _} ->
            prev = [last | prev]

            {:cont, {nil, i + 1, n, prev, m}}
        end
      end
  end)

case r do
  {{x, y, z}, i} ->
    IO.puts(
      "The three numbers are: #{inspect({x, y, z})}, sum is #{x + y + z} and the product is #{
        x * y * z
      }. Answer was found in #{i} iterations."
    )

  r ->
    IO.inspect(r, label: "result")
end
