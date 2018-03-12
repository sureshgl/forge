package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.State_dependent_path_declarationContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class State_dependent_path_declarationContextExt extends AbstractBaseExt {

	public State_dependent_path_declarationContextExt(State_dependent_path_declarationContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public State_dependent_path_declarationContext getContext() {
		return (State_dependent_path_declarationContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).state_dependent_path_declaration());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof State_dependent_path_declarationContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ State_dependent_path_declarationContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}