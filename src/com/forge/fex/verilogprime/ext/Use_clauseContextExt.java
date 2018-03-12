package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Use_clauseContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Use_clauseContextExt extends AbstractBaseExt {

	public Use_clauseContextExt(Use_clauseContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Use_clauseContext getContext() {
		return (Use_clauseContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).use_clause());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Use_clauseContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(
						ctx.getClass().getSimpleName() + " cannot be cased to " + Use_clauseContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}