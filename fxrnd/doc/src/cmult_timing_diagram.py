import schemdraw
from schemdraw import logic

d = schemdraw.Drawing()

with schemdraw.Drawing(file='cmult_timing_diagram.png') as d:
    logic.TimingDiagram(
        {'signal': [
            {'name': 'clk'        , 'wave': 'P.............'},
            {'name': 'i_enable'   , 'wave': '0..1...0..1...'},
            ['<8,1>',
            {'name': 'i_data_a[0]', 'wave': 'x.555555...5.5', 'data': ['8d38','8d24','8d38','-8d19','8d32','-8d25','8d64','8d76']},
            {'name': 'i_data_a[1]', 'wave': 'x.666666...6.6', 'data': ['-8d22','8d31','8d26','8d45','-8d13','-8d32','8d13','8d64']},
            ],
            ['<8,1>',
            {'name': 'i_data_b[0]', 'wave': 'x.555555...5.5', 'data': ['8d110','8d72','8d64','-8d51','8d83','8d51','8d58','-8d70']},
            {'name': 'i_data_b[1]', 'wave': 'x.666666...6.6', 'data': ['-8d73','-8d109','8d89','8d77','8d19','-8d38','8d102','-8d57']},
            ],
            ['<8,1>',
            {'name': 'o_data[0]'  , 'wave': 'x.....99...999', 'data': ['8d40','8d11','-8d15','8d12','-8d7']},
            {'name': 'o_data[1]'  , 'wave': 'x.....44...444', 'data': ['-8d3','8d2','8d0','8d0','8d1']},
            ],
         ],
         'config': {'hscale': 1.5}
         }, risetime=.05, grid=True, gridcolor='gray')
