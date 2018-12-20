#ifndef _BASICS_H
#define _BASICS_H

#include <vector>
#include <cstdlib>
#include <iostream>

using namespace std;

enum Quiet {
    LOUD = 0,
    QUIET_NORMAL = 1,
    QUIET_VERY = 2
};

class CSolverConf
{
public:
    static bool analyzeConflicts;
    static bool doNonChronBackTracking;

    static enum Quiet quietMode;

    static bool allowComponentCaching;
    static bool allowImplicitBCP;

    static bool allowPreProcessing;

    static unsigned int secsTimeBound;

    static unsigned int maxCacheSize;   // maximum Cache Size in bytes
    
    static int nodeCount; // Nodes currently in use
    
    static bool smoothNNF;
    static bool ensureAllLits;
    
    static bool disableDynamicDecomp;

    CSolverConf();

    ~CSolverConf();

};

#ifdef COMPILE_FOR_GUI
#define toSTDOUT(X)
#define verySTDOUT(X)
#else
#define toSTDOUT(X)	if(CSolverConf::quietMode < QUIET_NORMAL) cout << X;
#define verySTDOUT(X)	if(CSolverConf::quietMode < QUIET_VERY)   cout << X;
#endif

#ifdef DEBUG
#define toDEBUGOUT(X) if(!CSolverConf::quietMode) cout << X;
#else
#define toDEBUGOUT(X)
#endif

enum SOLVER_StateT
{

    SUCCESS,
    TIMEOUT,
    ABORTED
};

enum TriValue
{

    F = 0,
    W = 1,
    X = 2
};

enum DT_NodeType
{
    DT_AND,
    DT_OR,
    DT_LIT,
    DT_TOP,
    DT_BOTTOM
};


extern char TriValuetoChar(TriValue v);
#endif
