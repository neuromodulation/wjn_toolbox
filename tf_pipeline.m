%-----------------------------------------------------------------------
% Job saved on 18-Sep-2015 11:58:25 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6470)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.meeg.tf.tf.D = {'E:\Dropbox\Motorneuroscience\beta_invaders\spmeeg_364EE54.mat'};
matlabbatch{1}.spm.meeg.tf.tf.channels{1}.all = 'all';
matlabbatch{1}.spm.meeg.tf.tf.channels{2}.type = 'LFP';
matlabbatch{1}.spm.meeg.tf.tf.frequencies = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350];
matlabbatch{1}.spm.meeg.tf.tf.timewin = [-Inf Inf];
matlabbatch{1}.spm.meeg.tf.tf.method.mtmspec.timeres = 100;
matlabbatch{1}.spm.meeg.tf.tf.method.mtmspec.timestep = 10;
matlabbatch{1}.spm.meeg.tf.tf.method.mtmspec.bandwidth = 3;
matlabbatch{1}.spm.meeg.tf.tf.phase = 0;
matlabbatch{1}.spm.meeg.tf.tf.prefix = '';
matlabbatch{2}.spm.meeg.averaging.average.D(1) = cfg_dep('Time-frequency analysis: M/EEG time-frequency power dataset', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dtfname'));
matlabbatch{2}.spm.meeg.averaging.average.userobust.robust.ks = 3;
matlabbatch{2}.spm.meeg.averaging.average.userobust.robust.bycondition = false;
matlabbatch{2}.spm.meeg.averaging.average.userobust.robust.savew = false;
matlabbatch{2}.spm.meeg.averaging.average.userobust.robust.removebad = true;
matlabbatch{2}.spm.meeg.averaging.average.plv = false;
matlabbatch{2}.spm.meeg.averaging.average.prefix = 'm';
matlabbatch{3}.spm.meeg.tf.rescale.D(1) = cfg_dep('Averaging: Averaged Datafile', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','Dfname'));
matlabbatch{3}.spm.meeg.tf.rescale.method.Rel.baseline.timewin = [-Inf Inf];
matlabbatch{3}.spm.meeg.tf.rescale.method.Rel.baseline.Db = [];
matlabbatch{3}.spm.meeg.tf.rescale.prefix = 'r';
