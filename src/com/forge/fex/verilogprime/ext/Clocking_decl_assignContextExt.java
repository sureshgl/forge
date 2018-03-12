package com.forge.fex.verilogprime.ext;

import org.antlr.v4.runtime.ParserRuleContext;

import com.forge.fex.verilogprime.gen.VerilogPrimeParser.Clocking_decl_assignContext;
import com.forge.fex.verilogprime.utils.PopulateExtendedContextVisitor;

public class Clocking_decl_assignContextExt extends AbstractBaseExt {

	public Clocking_decl_assignContextExt(Clocking_decl_assignContext ctx) {
		addToContexts(ctx);
		parent = ctx;
	}

	@Override
	public Clocking_decl_assignContext getContext() {
		return (Clocking_decl_assignContext) contexts.get(contexts.size() - 1);
	}

	@Override
	public ParserRuleContext getContext(String str) {
		return new PopulateExtendedContextVisitor().visit(getPrimeParser(str).clocking_decl_assign());
	}

	@Override
	public void setContext(ParserRuleContext ctx) {
		if (ctx != null) {
			if (ctx instanceof Clocking_decl_assignContext) {
				addToContexts(ctx);
			} else {
				throw new ClassCastException(ctx.getClass().getSimpleName() + " cannot be cased to "
						+ Clocking_decl_assignContext.class.getName());
			}
		} else {
			addToContexts(null);
		}
	}
}