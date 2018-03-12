package com.forge.parser.ext;

import java.util.Map;

import com.forge.parser.EvaluateVisitorForForge;

public abstract class ExpressionContextExt extends AbstractBaseExt {
	
	@Override
	public void resolveParameters(Map<String,String> topModuleParameters){
		EvaluateVisitorForForge ev = new EvaluateVisitorForForge(topModuleParameters);
		addToContexts(getContext(ev.visit(getContext())));
	}
}
