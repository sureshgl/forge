package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Pass_en_switchtypeContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Pass_en_switchtypeContextExt extends AbstractBaseExt {

	public Pass_en_switchtypeContextExt(Pass_en_switchtypeContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Pass_en_switchtypeContext getContext() {
		return (Pass_en_switchtypeContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).pass_en_switchtype());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Pass_en_switchtypeContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Pass_en_switchtypeContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}