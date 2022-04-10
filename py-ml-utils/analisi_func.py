import numpy as np

def imputazione_valori_mancanti(df, miss_list=None, values_dict=None):

    if values_dict != None:
        for k in values_dict:
            df.loc[df[k].isnull(), k] = values_dict[k]
        return df
    else:
        imputed_values = {}
        for el in miss_list:
            col_list = el['col_list']
            if 'area' in el:
                area = el['area']
                print(area)
            else:
                print(col_list[0])
            if 'method' in el:
                method = el['method']
            else:
                method = None
                val = el['value']
            print('missing: {}%'.format(sum(df[col_list[0]].isnull()) * 100 / len(df)))  
            for col in col_list:
                if method == None:
                    m = val
                else:
                    if method == 'median':
                        m = df[col].median()
                imputed_values[col] = m
                df.loc[df[col].isnull(), col] = m
            print('')

        return df, imputed_values

        return df, imputed_values


def restringi_percentili(x, inf=1, perc_sup=99):
    x_inf = np.percentile(x, q=perc_inf)
    x_sup = np.percentile(x, q=perc_sup)
    
    x[x < x_inf] = x_inf
    x[x > x_sup] = x_sup
    
    return x


def woe_encoding(df, col, target, smooth=False, m=10):

    means = df.groupby(col)[target].mean()
    means = np.maximum(0.01, np.minimum(0.99, means))
    woes = np.log(np.divide(means, 1-means))

    if smooth:
        counts = df.groupby(col)[target].count()
        mean = df[target].mean()
        woe = np.log(mean / (1-mean))
        woes = (counts * woes + m * woe) / (counts + m)

    return df[col].map(woes), woes.to_dict()


def mean_encoding(df, col, target, smooth=False, m=10):

    means = df.groupby(col)[target].mean()

    if smooth:
        counts = df.groupby(col)[target].count()
        mean = df[target].mean()
        means = (counts * means + m * mean) / (counts + m)

    return df[col].map(means), means.to_dict()