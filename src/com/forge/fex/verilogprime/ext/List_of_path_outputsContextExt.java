package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.List_of_path_outputsContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class List_of_path_outputsContextExt extends AbstractBaseExt {

	public List_of_path_outputsContextExt(List_of_path_outputsContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public List_of_path_outputsContext getContext() {
		return (List_of_path_outputsContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).list_of_path_outputs());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof List_of_path_outputsContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ List_of_path_outputsContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}