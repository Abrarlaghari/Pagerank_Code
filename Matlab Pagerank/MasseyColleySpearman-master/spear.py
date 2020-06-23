'''Quick look to get Pearson coefficient of two lists'''
import pylab

def loadTeam(fname):
    return [line.strip() for line in open(fname)]

#not used
def makeDict(sourceList):
    retDict = {}
    for i in range(len(sourceList)):
        retDict[i+1]=sourceList[i]
    return retDict

def fakeDict(sourceList):
    #you can't get keys  based on values in a python dict, apparently
    #so just make a list of tuples
    retDict = []
    for i in range(len(sourceList)):
        #need to add 1 since no team is ranked 0
        retDict.append((i+1,sourceList[i]))
    return retDict

def Spearman(m,c):
	#make sure the lists are the same length
    assert len(m) == len(c)
    assert len(m) == 351
    #brute force search
    #could build a dictionary with ranks instead if perf is a concern
    #or move the plot code here and produce the plot at the same time
    sum = 0
    colleyIndex = 1
    for team in c:
        masseyIndex = 1
        for mteam in m:
            if mteam != team:#then this is not a match, so check next team
                masseyIndex+=1
            else:
                break
        sum+=(masseyIndex-colleyIndex)**2
        colleyIndex+=1
    n=len(c)
    spearmancoeff = float(1.0-(6.0*sum)/(n*(n**2-1)))
    return spearmancoeff

def makePlot(m,c):
    cd = fakeDict(c)
    md = fakeDict(m)
    plotPoints = []
    #inefficient code
    mval = 0
    jc=[] #just the colley ranks, used for the scatter plot
    jm=[] #just massey ranks, used for scatter
    for mteam in md:
        mval+=1
        #go through team list and append x and y as massey, colley
        cval = 1
        for cteam in cd:
            if cteam[1] == mteam[1]:
                plotPoints.append((mval,cval))#this plot did not make a lot of sense
                jm.append(mval)
                jc.append(cval)
                break
            else:
                cval+=1

    pylab.title("Compare Massey and Colley Team Rankings 2014")
    #pylab.plot(plotPoints)
    pylab.scatter(jm,jc)
    pylab.xlabel("Massey Rank")
    pylab.ylabel("Colley Rank")
    pylab.show()

#these are the output of the octave scripts from the class
c= loadTeam('ColleyRanks.txt')
m = loadTeam('MasseyRanks.txt')

print "Spearman coefficient of the two lists is ",Spearman(m,c)

#make a plot (but I am not sure what this means)
makePlot(m,c)