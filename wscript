# vim: set filetype=python :

import os.path

def configure(conf):
    conf.load('tex')
    conf.load('pandoc', tooldir='.')

def build(bld):
    def make_sources(parts):
        sources = []
        for ch in parts:
            if isinstance(ch, basestring):
                sources.append(ch + '.pd')
            elif isinstance(ch, tuple):
                chdir = 'ch_' + ch[0]
                sources.append(os.path.join(chdir, 'chapter.pd'))
                for sec in ch[1]:
                    sources.append(os.path.join(chdir, 'sec_' + sec + '.pd'))
                sources.append(os.path.join(chdir, 'conclusion.pd'))
            else:
                raise TypeError('Wrong part')
        return ' '.join(sources)
    sources = make_sources([
        'Introduction',
        ('01', [ #Review
            '1_Blockchain',
            # '2_Consensus',
            # '3_Cryptocurrencies_existing', #Informal review, highlighting major components, short comparison of support by various currencies, note on fomalization efforts (none)
            # '4_Cryptocurrency_research'
        ]),
        # ('02', [ #Task definition
        #     '1_Problem',
        #     '2_Previous',
        #     '3_Task',
        # ]),
        # ('03', [ #Model
        #     '1_Structure',
        #     '2_State',
        #     '3_Block',
        #     # '4_Consensus',
        # ]),
        'Conclusion',
    ])
    pdfname='agapov-master-thesis'
    bld(features='pandoc-merge', source=sources + ' bib.bib', target=pdfname + '.latex',
            disabled_exts='fancy_lists', 
            flags='-f markdown+raw_tex+smart --pdf-engine=xelatex --listings --top-level-division=chapter',
            linkflags='--toc --top-level-division=chapter -f markdown+raw_tex', template='template.latex')
    # Outputs main.pdf
    bld(features='tex', type='xelatex', source=pdfname + '.latex', flags='--shell-escape', 
            prompt=True)
    bld.add_manual_dependency(bld.bldnode.find_or_declare(pdfname + '.pdf'),
                              bld.srcnode.find_node('utf8gost705u.bst'))
