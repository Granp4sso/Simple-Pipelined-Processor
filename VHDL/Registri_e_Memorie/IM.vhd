library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity IM is

port(reset     : in std_logic;
en: in std_logic;
clk: in std_logic;
instr_address: in std_logic_vector(7 downto 0) := "00000000";
instr_data: out std_logic_vector(15 downto 0) );
end IM;

architecture Behavioral of IM is
type ram_type is array(255 downto 0) of std_logic_vector(15 downto 0);
signal ram : ram_type;
signal read_data : std_logic_vector(15 downto 0);
begin
process(reset, clk, en)
begin
if (reset = '1') then
	instr_data <= (others => '0');
read_data <= x"0000";
ram(255 downto 0) <= (
0 => x"0000",
1 => x"9A01",
2 => x"9052",
3 => x"C050",
4 => x"9022",
5 => x"1123",
6 => x"0000",
7 => x"0000",
8 => x"0000",
9 => x"0000",
10 => x"0000",
11 => x"0000",
12 => x"0000",
13 => x"0000",
14 => x"0000",
15 => x"0000",
16 => x"0000",
17 => x"0000",
18 => x"0000",
19 => x"0000",
20 => x"0000",
21 => x"0000",
22 => x"0000",
23 => x"0000",
24 => x"0000",
25 => x"0000",
26 => x"0000",
27 => x"0000",
28 => x"0000",
29 => x"0000",
30 => x"0000",
31 => x"0000",
32 => x"0000",
33 => x"0000",
34 => x"0000",
35 => x"0000",
36 => x"0000",
37 => x"0000",
38 => x"0000",
39 => x"0000",
40 => x"0000",
41 => x"0000",
42 => x"0000",
43 => x"0000",
44 => x"0000",
45 => x"0000",
46 => x"0000",
47 => x"0000",
48 => x"0000",
49 => x"0000",
50 => x"0000",
51 => x"0000",
52 => x"0000",
53 => x"0000",
54 => x"0000",
55 => x"0000",
56 => x"0000",
57 => x"0000",
58 => x"0000",
59 => x"0000",
60 => x"0000",
61 => x"0000",
62 => x"0000",
63 => x"0000",
64 => x"0000",
65 => x"0000",
66 => x"0000",
67 => x"0000",
68 => x"0000",
69 => x"0000",
70 => x"0000",
71 => x"0000",
72 => x"0000",
73 => x"0000",
74 => x"0000",
75 => x"0000",
76 => x"0000",
77 => x"0000",
78 => x"0000",
79 => x"0000",
80 => x"0000",
81 => x"0000",
82 => x"0000",
83 => x"0000",
84 => x"0000",
85 => x"0000",
86 => x"0000",
87 => x"0000",
88 => x"0000",
89 => x"0000",
90 => x"0000",
91 => x"0000",
92 => x"0000",
93 => x"0000",
94 => x"0000",
95 => x"0000",
96 => x"0000",
97 => x"0000",
98 => x"0000",
99 => x"0000",
100 => x"0000",
101 => x"0000",
102 => x"0000",
103 => x"0000",
104 => x"0000",
105 => x"0000",
106 => x"0000",
107 => x"0000",
108 => x"0000",
109 => x"0000",
110 => x"0000",
111 => x"0000",
112 => x"0000",
113 => x"0000",
114 => x"0000",
115 => x"0000",
116 => x"0000",
117 => x"0000",
118 => x"0000",
119 => x"0000",
120 => x"0000",
121 => x"0000",
122 => x"0000",
123 => x"0000",
124 => x"0000",
125 => x"0000",
126 => x"0000",
127 => x"0000",
128 => x"0000",
129 => x"0000",
130 => x"0000",
131 => x"0000",
132 => x"0000",
133 => x"0000",
134 => x"0000",
135 => x"0000",
136 => x"0000",
137 => x"0000",
138 => x"0000",
139 => x"0000",
140 => x"0000",
141 => x"0000",
142 => x"0000",
143 => x"0000",
144 => x"0000",
145 => x"0000",
146 => x"0000",
147 => x"0000",
148 => x"0000",
149 => x"0000",
150 => x"0000",
151 => x"0000",
152 => x"0000",
153 => x"0000",
154 => x"0000",
155 => x"0000",
156 => x"0000",
157 => x"0000",
158 => x"0000",
159 => x"0000",
160 => x"0000",
161 => x"0000",
162 => x"0000",
163 => x"0000",
164 => x"0000",
165 => x"0000",
166 => x"0000",
167 => x"0000",
168 => x"0000",
169 => x"0000",
170 => x"0000",
171 => x"0000",
172 => x"0000",
173 => x"0000",
174 => x"0000",
175 => x"0000",
176 => x"0000",
177 => x"0000",
178 => x"0000",
179 => x"0000",
180 => x"0000",
181 => x"0000",
182 => x"0000",
183 => x"0000",
184 => x"0000",
185 => x"0000",
186 => x"0000",
187 => x"0000",
188 => x"0000",
189 => x"0000",
190 => x"0000",
191 => x"0000",
192 => x"0000",
193 => x"0000",
194 => x"0000",
195 => x"0000",
196 => x"0000",
197 => x"0000",
198 => x"0000",
199 => x"0000",
200 => x"0000",
201 => x"0000",
202 => x"0000",
203 => x"0000",
204 => x"0000",
205 => x"0000",
206 => x"0000",
207 => x"0000",
208 => x"0000",
209 => x"0000",
210 => x"0000",
211 => x"0000",
212 => x"0000",
213 => x"0000",
214 => x"0000",
215 => x"0000",
216 => x"0000",
217 => x"0000",
218 => x"0000",
219 => x"0000",
220 => x"0000",
221 => x"0000",
222 => x"0000",
223 => x"0000",
224 => x"0000",
225 => x"0000",
226 => x"0000",
227 => x"0000",
228 => x"0000",
229 => x"0000",
230 => x"0000",
231 => x"0000",
232 => x"0000",
233 => x"0000",
234 => x"0000",
235 => x"0000",
236 => x"0000",
237 => x"0000",
238 => x"0000",
239 => x"0000",
240 => x"0000",
241 => x"0000",
242 => x"0000",
243 => x"0000",
244 => x"0000",
245 => x"0000",
246 => x"0000",
247 => x"0000",
248 => x"0000",
249 => x"0000",
250 => x"0000",
251 => x"0000",
252 => x"0000",
253 => x"0000",
254 => x"0000",
255 => x"0000"
);
elsif falling_edge(clk) and en = '1' then
instr_data <= read_data;
elsif rising_edge(clk) and en = '1' then
read_data <= ram(to_integer(unsigned(instr_address)));
end if;
end process;

end Behavioral;