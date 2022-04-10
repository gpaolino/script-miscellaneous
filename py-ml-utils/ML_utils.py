def freq_tab(data, row_var, col_var, margins=True, perc=None):
    """
    Function that returns a frequency table between two columns of a
    pandas DataFrame. It can also calculate the row/column totals and
    the relative frequency.
    Parameters
    -----------
    data: pandas DataFrame
    row_var: feature of data to put in rows
    col_var: feature of data to put in columns
    margins: if True, it adds the row/column totals (default True)
    perc: if set to 'col' or 'row', it put the relative frequency by column
          or row (default None).
    Output
    -----------
    cr: pandas DataFrame result of a pandas.crosstab
    """

    cr = pd.crosstab(index=data[row_var],
                     columns=data[col_var],
                     margins=margins)
    if margins and perc in ('col', 'row'):
        cr.index = ['col_tot' if x == 'All' else x for x in cr.index.tolist()]
        cr.columns = ['row_tot' if x == 'All' else x for x in cr.columns.tolist()]

        if perc == 'col':
            cr = cr / cr.ix['col_tot']
        elif perc == 'row':
            cr = cr.div(cr['row_tot'], 0)

    return cr
    

def my_conf_matrix(conf_matrix, row_perc=False):
    a = pd.DataFrame(conf_matrix, index=['true: 0', 'true: 1'], columns=['pred: 0', 'pred: 1'])
    if row_perc:
        a.div(a.sum(axis=1), axis=1)
    return a